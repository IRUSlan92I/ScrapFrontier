class_name PlayerData
extends Resource


@export var weapon_ids: Array[String]

@export var hull: int


var is_new_game: bool = false


func reset() -> void:
	weapon_ids.clear()
	hull = 0
	is_new_game = true
