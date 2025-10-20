extends Node2D


func _process(delta: float) -> void:
	var speed := 100
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity := input_direction * speed
	position += velocity * delta
	var screen_size := get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, screen_size)
