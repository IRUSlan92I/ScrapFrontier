class_name MinelayerProjectile
extends BlastProjectile


@export var deceleration : int


@onready var sprite_on := $Sprite2D_On
@onready var sprite_off := $Sprite2D_Off
@onready var livetime_timer := $LivetimeTimer
@onready var sprite_on_timer := $SpriteOnTimer
@onready var sprite_off_timer := $SpriteOffTimer


const OFF_TIMES = [
	1.0, 1.0, 0.5, 0.25, 0.05, 0.05, 0.05, 0.05, 0.05,
]
const ON_TIME = 0.05


enum Sprite {
	ON,
	OFF,
}


var _bodies_inside: Array[Node2D] = []
var current_off_time_index := 0


func _ready() -> void:
	_switch_sprite(Sprite.OFF)
	super._ready()


func _physics_process(delta: float) -> void:
	_process_acceleration(delta)
	super._physics_process(delta)


func _process_acceleration(delta: float) -> void:
	var current_deceleration := deceleration * delta
	if _velocity.length() > current_deceleration:
		_velocity -= _velocity.normalized() * current_deceleration
	else:
		_velocity = Vector2.ZERO


func _on_livetime_timer_timeout() -> void:
	queue_free()


func _on_blast_body_entered(body: Node2D) -> void:
	_bodies_inside.append(body)
	_switch_sprite(Sprite.ON)
	if sprite_on_timer.is_stopped() and sprite_off_timer.is_stopped():
		sprite_on_timer.start(ON_TIME)


func _on_blast_body_exited(body: Node2D) -> void:
	if not body in _bodies_inside: return
	
	_bodies_inside.erase(body)
	
	if _bodies_inside.size() == 0:
		_reset()


func _on_sprite_on_timer_timeout() -> void:
	current_off_time_index += 1
	
	if current_off_time_index >= OFF_TIMES.size():
		_try_to_damage_by_blast()
		_process_hit_for_projectile(null)
	else:
		_switch_sprite(Sprite.OFF)
		sprite_off_timer.start(OFF_TIMES[current_off_time_index])


func _on_sprite_off_timer_timeout() -> void:
	_switch_sprite(Sprite.ON)
	sprite_on_timer.start(ON_TIME)


func _reset() -> void:
	_switch_sprite(Sprite.OFF)
	sprite_on_timer.stop()
	sprite_off_timer.stop()
	current_off_time_index = 0


func _switch_sprite(sprite: Sprite) -> void:
	match sprite:
		Sprite.ON:
			sprite_on.show()
			sprite_off.hide()
		Sprite.OFF:
			sprite_on.hide()
			sprite_off.show()
