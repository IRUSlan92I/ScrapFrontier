extends Node


var position : Vector2:
	set(value):
		$Ship.position = value
	get:
		return $Ship.position
		

func _process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	$Ship.accelerate(input_direction, delta)
