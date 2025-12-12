extends Node


const SAVE_FILE = "user://save.bin"
const SAVE_FILE_PASS = "save_file_data"

const CATEGORY_GAME = "game"
const PARAMETER_GAME_SEED = "seed"
const PARAMETER_GAME_AREA_INDEX = "current_area_index"
const PARAMETER_GAME_STAGE_INDEX = "current_stage_index"
const PARAMETER_GAME_SECTOR_INDEX = "current_sector_index"


var _save_file: ConfigFile

var game_data : GameData


func _ready() -> void:
	_load()


func save() -> void:
	_save_file.set_value(CATEGORY_GAME, PARAMETER_GAME_SEED, game_data.game_seed)
	_save_file.set_value(CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_area_index)
	_save_file.set_value(CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_stage_index)
	_save_file.set_value(CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_sector_index)
	
	_save_file.save_encrypted_pass(SAVE_FILE, SAVE_FILE_PASS)


func new_game() -> void:
	game_data.randomize()


func delete_game_data() -> void:
	game_data = GameData.new()
	save()


func _load() -> void:
	_save_file = ConfigFile.new()
	game_data = GameData.new()
	
	if _save_file.load_encrypted_pass(SAVE_FILE, SAVE_FILE_PASS) == OK:
		_process_save_file()
	
	save()


func _process_save_file() -> void:
	game_data.game_seed  = _save_file.get_value(
		CATEGORY_GAME, PARAMETER_GAME_SEED, game_data.game_seed
	)
	game_data.current_area_index  = _save_file.get_value(
		CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_area_index
	)
	game_data.current_stage_index  = _save_file.get_value(
		CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_stage_index
	)
	game_data.current_sector_index  = _save_file.get_value(
		CATEGORY_GAME, PARAMETER_GAME_AREA_INDEX, game_data.current_sector_index
	)
