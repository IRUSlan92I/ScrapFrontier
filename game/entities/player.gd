extends Node


var position : Vector2:
	set(value):
		$Ship.position = value
	get:
		return $Ship.position
		

func _process(delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	print(input_direction)
	
	if input_direction.is_zero_approx():
		$Ship.decelerate($Ship.deceleration * delta)
	else:
		var acceleration : Vector2 = input_direction * $Ship.acceleration * delta
		$Ship.accelerate(acceleration)
