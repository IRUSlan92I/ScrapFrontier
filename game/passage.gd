extends Node


func _ready() -> void:
	const PLAYER := preload("res://game/entities/ships/player_ship.tscn")
	var player : PlayerShip = PLAYER.instantiate()
	add_child(player)
	player.position = Vector2(100, 100)
