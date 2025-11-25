class_name EnemyController
extends Node


signal accelerate(direction: Vector2, delta: float)
signal shoot()


@export var ship: AbstractEnemyShip


const FREE_FLIGHT_DIST = 50


var target_position : Vector2
var direction : Vector2


func _physics_process(delta: float) -> void:
	if ship.is_on_screen:
		shoot.emit()
	accelerate.emit(direction, delta)


func _on_direction_timer_timeout() -> void:
	direction = get_acceleration_direction()


func get_acceleration_direction() -> Vector2:
	var distance := ship.position.distance_to(target_position)
	
	if distance < FREE_FLIGHT_DIST:
		return Vector2.ZERO
	
	var direction_to_target := (target_position - ship.position).normalized()
	var speed_to_target := ship.velocity.dot(direction_to_target)
	
	var slow_down_distance := speed_to_target/ship.acceleration * speed_to_target
	
	var speed_coef := distance / (slow_down_distance + FREE_FLIGHT_DIST)
	
	var target_speed := ship.max_speed * clampf(speed_coef, 0.0, 1.0)
	var target_velocity := direction_to_target * target_speed
	
	var delta_velocity := target_velocity - ship.velocity
	
	return direction_to_target * ship.max_speed/delta_velocity.length()
