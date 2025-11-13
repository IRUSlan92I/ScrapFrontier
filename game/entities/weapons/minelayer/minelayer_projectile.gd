class_name MinelayerProjectile
extends AbstractProjectile


@export var deceleration : int


@onready var livetime_timer := $LivetimeTimer


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
