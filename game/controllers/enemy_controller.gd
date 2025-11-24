class_name EnemyController
extends Node


signal accelerate(direction: Vector2, delta: float)
signal shoot()


@export var ship: AbstractEnemyShip


var target_position : Vector2
var direction : Vector2


func _physics_process(delta: float) -> void:
	if ship.is_on_screen:
		shoot.emit()
	accelerate.emit(direction, delta)


func _on_direction_timer_timeout() -> void:
	direction = get_acceleration_direction()


func get_acceleration_direction() -> Vector2:
	return (target_position - ship.position).normalized()
