extends Node


var position : Vector2:
	set(value):
		$Ship.position = value
	get:
		return $Ship.position


func _process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$Ship.accelerate(input_direction, delta)
	
	var weapons : Array = $Ship.weapons
	var weapon_actions := { 0: "shoot_weapon_1", 1: "shoot_weapon_2" }
	for index : int in weapon_actions:
		if Input.is_action_pressed(weapon_actions[index], true) and weapons.size() > index:
			$Ship.shoot(weapons[index])
