class_name PlayerController
extends Node


signal accelerate(direction: Vector2, delta: float)

signal shoot(weapon_index: int)


const WEAPON_ACTIONS := {
	0: "shoot_weapon_1",
	1: "shoot_weapon_2",
}


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	accelerate.emit(input_direction, delta)
	
	for index : int in WEAPON_ACTIONS:
		if Input.is_action_pressed(WEAPON_ACTIONS[index]):
			shoot.emit(index)
