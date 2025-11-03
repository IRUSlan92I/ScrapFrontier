extends Node


@onready var ship := $Ship


var position : Vector2:
	set(value):
		ship.position = value
	get:
		return ship.position

  
func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	ship.accelerate(input_direction, delta)
	
	var weapons : Array[Weapon] = ship.weapons
	var weapon_actions := {
		0: ["shoot_weapon_1", "reload_weapon_1"],
		1: ["shoot_weapon_2", "reload_weapon_2"]
	}
	for index : int in weapon_actions:
		if index >= weapons.size(): break
		
		if Input.is_action_pressed(weapon_actions[index][0]):
			ship.shoot(weapons[index])
		
		if Input.is_action_pressed(weapon_actions[index][1]):
			ship.reload(weapons[index])
