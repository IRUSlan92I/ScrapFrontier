extends Node


const SAVE_FILE = "user://save.bin"
const SAVE_FILE_PASS = "save_file_data"

const CATEGORY_GAME = "game"
const GAME_SEED = "seed"
const GAME_AREA_INDEX = "current_area_index"
const GAME_STAGE_INDEX = "current_stage_index"
const GAME_SECTOR_INDEX = "current_sector_index"

const CATEGORY_PLAYER = "game"
const PLAYER_FIRST_WEAPON = "player_first_weapon_id"
const PLAYER_SECOND_WEAPON = "player_second_weapon_id"


var _save_file: ConfigFile

var game_data : GameData
var player_data : PlayerData


func _ready() -> void:
	_save_file = ConfigFile.new()
	game_data = GameData.new()
	player_data = PlayerData.new()
	
	_load()


func save() -> void:
	_set_game_values()
	_set_player_values()
	
	_save_file.save_encrypted_pass(SAVE_FILE, SAVE_FILE_PASS)


func new_game() -> void:
	game_data.randomize()


func delete_game_data() -> void:
	game_data = GameData.new()
	save()


func _load() -> void:
	if _save_file.load_encrypted_pass(SAVE_FILE, SAVE_FILE_PASS) == OK:
		_process_save_file()
	
	save()


func _process_save_file() -> void:
	_get_game_values()
	_get_player_values()


func _set_game_values() -> void:
	_save_file.set_value(CATEGORY_GAME, GAME_SEED, game_data.game_seed)
	_save_file.set_value(CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_area_index)
	_save_file.set_value(CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_stage_index)
	_save_file.set_value(CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_sector_index)


func _set_player_values() -> void:
	_save_file.set_value(CATEGORY_PLAYER, PLAYER_FIRST_WEAPON, player_data.first_weapon_id)
	_save_file.set_value(CATEGORY_PLAYER, PLAYER_SECOND_WEAPON, player_data.second_weapon_id)


func _get_game_values() -> void:
	game_data.game_seed  = _save_file.get_value(
		CATEGORY_GAME, GAME_SEED, game_data.game_seed
	)
	game_data.current_area_index  = _save_file.get_value(
		CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_area_index
	)
	game_data.current_stage_index  = _save_file.get_value(
		CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_stage_index
	)
	game_data.current_sector_index  = _save_file.get_value(
		CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_sector_index
	)


func _get_player_values() -> void:
	player_data.first_weapon_id  = _save_file.get_value(
		CATEGORY_PLAYER, PLAYER_FIRST_WEAPON, player_data.first_weapon_id
	)
	player_data.second_weapon_id  = _save_file.get_value(
		CATEGORY_PLAYER, PLAYER_SECOND_WEAPON, player_data.second_weapon_id
	)
