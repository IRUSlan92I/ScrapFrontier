class_name AbstractMinelayerProjectile
extends AbstractBlastProjectile


enum SpriteState {
	ON,
	OFF,
	Disabled,
}


const OFF_TIMES = [
	1.0, 1.0, 0.5, 0.25, 0.05, 0.05, 0.05, 0.05, 0.05,
]
const ON_TIME = 0.05

const SCROLL_VELOCITY = Vector2(-50, 0)


@export var deceleration : int


var _bodies_inside: Array[Node2D] = []
var _current_off_time_index := 0
var _current_sprite_state : SpriteState:
	set = _switch_sprite


@onready var sprite_on := $Sprite2D_On
@onready var sprite_off := $Sprite2D_Off
@onready var sprite_on_timer := $SpriteOnTimer
@onready var sprite_off_timer := $SpriteOffTimer
@onready var explosion_particles : ExplosionParticles = $ExplosionParticles


func _ready() -> void:
	_current_sprite_state = SpriteState.OFF
	super._ready()


func _physics_process(delta: float) -> void:
	_process_acceleration(delta)
	super._physics_process(delta)


func _process_acceleration(delta: float) -> void:
	var delta_velocity := SCROLL_VELOCITY - _velocity
	var new_direction := delta_velocity.normalized()
	var current_deceleration := clampf(delta_velocity.length(), 0.0, deceleration * delta)
	
	_velocity += new_direction * current_deceleration


func _on_blast_body_entered(body: Node2D) -> void:
	_bodies_inside.append(body)
	_current_sprite_state = SpriteState.ON
	if sprite_on_timer.is_stopped() and sprite_off_timer.is_stopped():
		sprite_on_timer.start(ON_TIME)


func _on_blast_body_exited(body: Node2D) -> void:
	if not body in _bodies_inside: return
	
	_bodies_inside.erase(body)
	
	if _bodies_inside.size() == 0:
		_reset()


func _on_sprite_on_timer_timeout() -> void:
	_current_off_time_index += 1
	
	if _current_off_time_index >= OFF_TIMES.size():
		_try_to_damage_by_blast()
		_process_hit_for_projectile(null)
	else:
		_current_sprite_state = SpriteState.OFF
		sprite_off_timer.start(OFF_TIMES[_current_off_time_index])


func _on_sprite_off_timer_timeout() -> void:
	_current_sprite_state = SpriteState.ON
	sprite_on_timer.start(ON_TIME)


func _reset() -> void:
	_current_sprite_state = SpriteState.OFF
	sprite_on_timer.stop()
	sprite_off_timer.stop()
	_current_off_time_index = 0


func _switch_sprite(new_state_state: SpriteState) -> void:
	if _current_sprite_state == SpriteState.Disabled: return
	
	_current_sprite_state = new_state_state
	match _current_sprite_state:
		SpriteState.ON:
			sprite_on.show()
			sprite_off.hide()
		SpriteState.OFF:
			sprite_on.hide()
			sprite_off.show()
		SpriteState.Disabled:
			sprite_on.hide()
			sprite_off.hide()


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	_current_sprite_state = SpriteState.Disabled
	explosion_particles.emitting = true
	set_physics_process(false)
	collision_mask = 0
	blast.collision_mask = 0


func _on_explosion_particles_finished() -> void:
	queue_free()
