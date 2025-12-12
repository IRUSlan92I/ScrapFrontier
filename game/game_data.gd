class_name GameData
extends Resource

const SEED_CHARS := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const DEFAULT_SEED_LENGTH := 16


@export var game_seed: String
@export var current_area_index: int
@export var current_stage_index: int
@export var current_sector_index: int


func randomize() -> void:
	var seed_chars_length := SEED_CHARS.length()
	
	for i in range(DEFAULT_SEED_LENGTH):
		var index := randi_range(1, seed_chars_length) - 1
		game_seed += SEED_CHARS[index]
	
	current_area_index = 0
	current_stage_index = 0
	current_sector_index = 0
