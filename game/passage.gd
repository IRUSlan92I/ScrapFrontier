extends Node


func _ready() -> void:
	var player : Node = load("res://game/entities/player.tscn").instantiate()
	add_child(player)
	player.position = Vector2(100, 100)
