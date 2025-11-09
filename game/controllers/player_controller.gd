class_name PlayerController
extends Node


signal accelerate(direction: Vector2, delta: float)

signal shoot(weapon_index: int)

signal reload(weapon_index: int)


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	accelerate.emit(input_direction, delta)
	
	var weapon_actions := {
		0: ["shoot_weapon_1", "reload_weapon_1"],
		1: ["shoot_weapon_2", "reload_weapon_2"]
	}
	for index : int in weapon_actions:
		if Input.is_action_pressed(weapon_actions[index][0]):
			shoot.emit(index)
		
		if Input.is_action_pressed(weapon_actions[index][1]):
			reload.emit(index)
