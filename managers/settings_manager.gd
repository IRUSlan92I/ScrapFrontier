extends Node


const CONFIG_FILE = "user://settings.cfg"
const BASE_SIZE = Vector2i(640, 360)

const CATEGORY_VIDEO = "video"
const SETTING_FULLSCREEN = "fullscreen"
const SETTING_WINDOW_FACTOR = "window_factor"


var _config: ConfigFile

var _fullscreen := false
var fullscreen : bool:
	get:
		return _fullscreen
	set(value):
		_fullscreen = value
		_apply_video_settings()
		_save_settings()

var _window_factor := 0
var window_factor : int:
	get:
		return _window_factor
	set(value):
		_window_factor = value
		_apply_video_settings()
		_save_settings()


func _ready() -> void:
	_load_settings()
	_apply_all_settings()


func _load_settings() -> void:
	_config = ConfigFile.new()
	
	if _config.load(CONFIG_FILE) == OK:
		_fullscreen = _config.get_value(CATEGORY_VIDEO, SETTING_FULLSCREEN, false)
		_window_factor = _config.get_value(CATEGORY_VIDEO, SETTING_WINDOW_FACTOR, 0)

	_save_settings()


func _save_settings() -> void:
	if _config == null:
		_config = ConfigFile.new()
	
	_config.set_value(CATEGORY_VIDEO, SETTING_FULLSCREEN, _fullscreen)
	_config.set_value(CATEGORY_VIDEO, SETTING_WINDOW_FACTOR, _window_factor)
	
	_config.save(CONFIG_FILE)


func _apply_all_settings() -> void:
	_apply_video_settings()


func _apply_video_settings() -> void:
	if _fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_apply_window_scale()


func _apply_window_scale() -> void:
	if _fullscreen: return
	
	var factors := [1, 2, 3, 4, 5, 6]
	
	var factor_index := _window_factor
	if factor_index >= factors.size():
		factor_index = 0
	
	var scale : int = factors[factor_index] 
	var new_size := BASE_SIZE * scale
		
	var current_position := DisplayServer.window_get_position()
	var current_size := DisplayServer.window_get_size()
	
	var current_center := current_position + current_size / 2
	var new_position := current_center - new_size / 2
	
	DisplayServer.window_set_size(new_size)
	DisplayServer.window_set_position(new_position)
	
	_ensure_window_on_screen()


func _ensure_window_on_screen() -> void:
	if _fullscreen: return
	
	var window_position := DisplayServer.window_get_position()
	var window_size := DisplayServer.window_get_size()
	var screen_size := DisplayServer.screen_get_size()
	
	var new_x : int = clamp(window_position.x, 0, screen_size.x - window_size.x)
	var new_y : int = clamp(window_position.y, 0, screen_size.y - window_size.y)
	
	if new_x != window_position.x or new_y != window_position.y:
		DisplayServer.window_set_position(Vector2i(new_x, new_y))
