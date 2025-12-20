class_name AbstractTeslaProjectile
extends AbstractDirectHitProjectile


@export_range(0.01, 0.5) var jink_min_delay: float = 0.01
@export_range(0.01, 0.5) var jink_max_delay: float = 0.01
@export_range(0, 360) var deviation_angle: int = 0
@export_range(0, 1000) var no_deviation_distance: int = 0


var _collided_foes : Array[AbstractShip] = []


@onready var jinkTimer : Timer = $JinkTimer

@onready var particles_huge : GPUParticles2D = $ParticlesHuge
@onready var particles_large : GPUParticles2D = $ParticlesLarge
@onready var particles_medium : GPUParticles2D = $ParticlesMedium
@onready var particles_small : GPUParticles2D = $ParticlesSmall


func _ready() -> void:
	super._ready()
	_start_jink_timer()


func _process_hit_for_projectile(collided_body: Node2D) -> void:
	if collided_body is AbstractShip:
		_collided_foes.append(collided_body)
		match _collided_foes.size():
			1: particles_huge.emitting = false
			2: particles_large.emitting = false
			3: particles_medium.emitting = false
	
	damage.value = floor(damage.value/2.0)
	
	if damage.value == 0:
		queue_free()
	else:
		_apply_random_deviation()
		_start_jink_timer()


func _start_jink_timer() -> void:
	var random_delay := randf_range(jink_min_delay, jink_max_delay)
	jinkTimer.start(random_delay)


func _on_jink_timer_timeout() -> void:
	var foe := _get_nearest_foe(_collided_foes)
	if foe:
		_target_foe(foe)
		if position.distance_to(foe.position) > no_deviation_distance:
			_apply_random_deviation()
	else:
		_apply_random_deviation()
	
	_start_jink_timer()


func _target_foe(foe: AbstractShip) -> void:
	var current_speed := _velocity.length()
	var foe_direction := position.direction_to(foe.position)
	_velocity = current_speed * foe_direction


func _apply_random_deviation() -> void:
	var deviation_rad := deg_to_rad(deviation_angle)
	var random_angle := randfn(0.0, deviation_rad / 6.0)
	_velocity = _velocity.rotated(random_angle)
