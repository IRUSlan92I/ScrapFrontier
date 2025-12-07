class_name PlayerController
extends Node


signal accelerate(direction: Vector2, delta: float)

signal shoot()

signal blink(direction: Vector2)


func _physics_process(delta: float) -> void:
	var input_direction := _get_input_direction()
	accelerate.emit(input_direction, delta)
	shoot.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("blink"):
		var input_direction := _get_input_direction()
		if not input_direction.is_zero_approx():
			blink.emit(input_direction)


func _get_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
