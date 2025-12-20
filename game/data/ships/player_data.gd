class_name PlayerData
extends Resource


@export var weapons: Array[WeaponData]

@export var hull: int


var is_new_game: bool = false


func reset() -> void:
	weapons.clear()
	hull = 0
	is_new_game = true
