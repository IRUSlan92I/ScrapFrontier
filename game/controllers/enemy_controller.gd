class_name EnemyController
extends Node


signal accelerate(direction: Vector2, delta: float)


const FREE_FLIGHT_DIST = 50


@export var ship: AbstractEnemyShip


var target_position : Vector2
var direction : Vector2


func _physics_process(delta: float) -> void:
	accelerate.emit(direction, delta)


func _on_direction_timer_timeout() -> void:
	direction = _get_acceleration_direction()


func _get_acceleration_direction() -> Vector2:
	var distance := ship.position.distance_to(target_position)
	
	if distance < FREE_FLIGHT_DIST:
		return Vector2.ZERO
	
	return (target_position - ship.position).normalized()
