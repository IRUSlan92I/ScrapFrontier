extends Node


const WEAPONS : Array[WeaponData] = [
	preload("res://game/data/weapons/cannon_data.tres"),
	preload("res://game/data/weapons/gatling_data.tres"),
	preload("res://game/data/weapons/laser_data.tres"),
	preload("res://game/data/weapons/launcher_data.tres"),
	preload("res://game/data/weapons/minelayer_data.tres"),
	preload("res://game/data/weapons/plasma_data.tres"),
	preload("res://game/data/weapons/railgun_data.tres"),
	preload("res://game/data/weapons/shrapnel_data.tres"),
	preload("res://game/data/weapons/tesla_data.tres"),
]

const SAVE_FILE = "user://save.bin"
const SAVE_FILE_PASS = "save_file_data"

const CATEGORY_GAME = "game"
const GAME_SEED = "seed"
const GAME_AREA_INDEX = "current_area_index"
const GAME_STAGE_INDEX = "current_stage_index"
const GAME_SECTOR_INDEX = "current_sector_index"

const CATEGORY_PLAYER = "player"
const PLAYER_WEAPONS = "weapon_ids"
const PLAYER_HULL = "hull"


var _save_file: ConfigFile

var game_data : GameData
var player_data : PlayerData


func _ready() -> void:
	_save_file = ConfigFile.new()
	game_data = GameData.new()
	player_data = PlayerData.new()
	
	_load()


static func get_weapon_data(weapon_id: String) -> WeaponData:
	for weapon in WEAPONS:
		if weapon.id == weapon_id:
			return weapon
	
	return null


func save() -> void:
	_set_game_values()
	_set_player_values()
	
	_save_file.save_encrypted_pass(SAVE_FILE, SAVE_FILE_PASS)


func new_game(game_seed: String) -> void:
	game_data.reset()
	player_data.reset()
	game_data.game_seed = game_seed


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
	_save_file.set_value(CATEGORY_GAME, GAME_STAGE_INDEX, game_data.current_stage_index)
	_save_file.set_value(CATEGORY_GAME, GAME_SECTOR_INDEX, game_data.current_sector_index)


func _set_player_values() -> void:
	var weapon_ids : Array[String] = []
	for weapon in player_data.weapons:
		weapon_ids.append(weapon.id)
	
	_save_file.set_value(CATEGORY_PLAYER, PLAYER_WEAPONS, weapon_ids)
	_save_file.set_value(CATEGORY_PLAYER, PLAYER_HULL, player_data.hull)


func _get_game_values() -> void:
	game_data.game_seed = _save_file.get_value(
		CATEGORY_GAME, GAME_SEED, game_data.game_seed
	)
	game_data.current_area_index = _save_file.get_value(
		CATEGORY_GAME, GAME_AREA_INDEX, game_data.current_area_index
	)
	game_data.current_stage_index = _save_file.get_value(
		CATEGORY_GAME, GAME_STAGE_INDEX, game_data.current_stage_index
	)
	game_data.current_sector_index = _save_file.get_value(
		CATEGORY_GAME, GAME_SECTOR_INDEX, game_data.current_sector_index
	)


func _get_player_values() -> void:
	var weapon_ids : Array[String] = _save_file.get_value(
		CATEGORY_PLAYER, PLAYER_WEAPONS, []
	)
	for weapon_id in weapon_ids:
		var weapon := get_weapon_data(weapon_id)
		if weapon != null:
			player_data.weapons.append(weapon)
	
	player_data.hull = _save_file.get_value(
		CATEGORY_PLAYER, PLAYER_HULL, player_data.hull
	)
