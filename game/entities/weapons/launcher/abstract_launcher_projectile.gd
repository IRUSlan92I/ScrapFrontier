class_name AbstractLauncherProjectile
extends AbstractBlastProjectile


@export_range(0, 360) var rotation_speed: int


var target : AbstractShip = null


@onready var sprites : Array[Sprite2D] = [
	$Sprites/E, $Sprites/SE, $Sprites/S, $Sprites/SW,
	$Sprites/W, $Sprites/NW, $Sprites/N, $Sprites/NE,
]
@onready var explosion_particles : ExplosionParticles = $ExplosionParticles


func _ready() -> void:
	_acquire_target()
	super._ready()
	_update_sprite(_velocity)


func _physics_process(delta: float) -> void:
	_apply_homing_guidance(delta)
	super._physics_process(delta)
	_update_sprite(_velocity)


func _acquire_target() -> void:
	target = _get_nearest_foe()


func _apply_homing_guidance(delta: float) -> void:
	if not target: return
	
	var max_angle_change := deg_to_rad(rotation_speed) * delta
	
	var current_angle := _velocity.angle()
	var target_angle := (target.position - position).angle()
	
	var angle_diff := wrapf(target_angle - current_angle, -PI, PI)
	var angle_change := clampf(angle_diff, -max_angle_change, max_angle_change)
	_velocity = _velocity.rotated(angle_change)


func _update_sprite(velocity: Vector2) -> void:
	if velocity.is_zero_approx():
		sprites[0].show()
		return
	
	var sector := TAU / sprites.size()
	var angle := velocity.angle()
	var bisector := angle + sector * 0.5
	
	var index := floori(fposmod(bisector, TAU) / sector)
	
	for sprite in sprites:
		sprite.hide()
	
	sprites[index].show()


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	for sprite in sprites:
		sprite.hide()
	explosion_particles.emitting = true
	set_physics_process(false)
	collision_mask = 0
	blast.collision_mask = 0


func _on_explosion_particles_finished() -> void:
	delete()
