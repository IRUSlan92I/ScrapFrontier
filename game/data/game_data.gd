class_name GameData
extends Resource




@export var game_seed: String
@export var current_area_index: int
@export var current_stage_index: int
@export var current_sector_index: int


func reset() -> void:
	game_seed = ""
	current_area_index = 0
	current_stage_index = 0
	current_sector_index = 0
