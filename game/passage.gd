extends Node


func _ready() -> void:
	var player : Node2D = load("res://game/entities/player.tscn").instantiate()
	player.position = Vector2(100, 100)
	add_child(player)
	
