class_name SeedSelectionMenu
extends Control


signal back


const SEED_CHARS := "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const DEFAULT_SEED_LENGTH := 16


var _seed_regex := RegEx.new()

var _old_custom_seed_length := -1


@onready var random_edit : LineEdit = $%RandomEdit
@onready var custom_edit : LineEdit = $%CustomEdit

@onready var use_random_button : Button = $%UseRandomButton
@onready var use_custom_button : Button = $%UseCustomButton

@onready var back_button : Button = $%BackButton


func _init() -> void:
	var regex_pattern := "[%s]+" % SEED_CHARS
	_seed_regex.compile(regex_pattern)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and _play_up_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_previous)
	if event.is_action_pressed("ui_down") and _play_down_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_next)
	if event.is_action_pressed("ui_left") and _play_left_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_previous)
	if event.is_action_pressed("ui_right") and _play_right_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_next)


func _play_up_sound() -> bool:
	match get_viewport().gui_get_focus_owner():
		use_custom_button, custom_edit, back_button: return true
	return false


func _play_down_sound() -> bool:
	match get_viewport().gui_get_focus_owner():
		use_random_button, use_custom_button, custom_edit: return true
	return false


func _play_left_sound() -> bool:
	match get_viewport().gui_get_focus_owner():
		use_random_button, use_custom_button, back_button: return true
	return false


func _play_right_sound() -> bool:
	match get_viewport().gui_get_focus_owner():
		custom_edit: return true
	return false


func _update_use_custom_button() -> void:
	var disabled := custom_edit.text.is_empty()
	use_custom_button.disabled = disabled
	use_custom_button.focus_mode = FOCUS_NONE if disabled else FOCUS_ALL


func _init_focus() -> void:
	_update_use_custom_button()
	use_random_button.grab_focus()


func _get_random_seed() -> String:
	var seed_chars_length := SEED_CHARS.length()
	
	var random_seed := ""
	for i in range(DEFAULT_SEED_LENGTH):
		var index := randi_range(1, seed_chars_length) - 1
		random_seed += SEED_CHARS[index]
	
	return random_seed


func _start_game(game_seed: String) -> void:
	SaveManager.new_game(game_seed)
	get_tree().change_scene_to_file("res://game/entities/world/game.tscn")


func _on_seed_edit_text_changed(new_text: String) -> void:
	var result := _seed_regex.search_all(new_text)
	
	var filtered_text := ""
	for text in result:
		filtered_text += text.get_string()
	
	if custom_edit.text != filtered_text:
		var caret_position := custom_edit.caret_column
		custom_edit.text = filtered_text
		custom_edit.caret_column = min(caret_position, filtered_text.length())
	
	if _old_custom_seed_length < custom_edit.text.length():
		SoundManager.play_ui_stream(SoundManager.ui_stream_next)
	elif _old_custom_seed_length > custom_edit.text.length():
		SoundManager.play_ui_stream(SoundManager.ui_stream_previous)
	
	_old_custom_seed_length = custom_edit.text.length()
		
	_update_use_custom_button()


func _on_seed_edit_text_submitted(new_text: String) -> void:
	if not new_text.is_empty():
		use_custom_button.grab_focus()


func _on_back_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_decline)
	back.emit()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	custom_edit.text = ""
	random_edit.text = _get_random_seed()
	
	_init_focus()


func _on_use_random_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	_start_game(random_edit.text)


func _on_use_custom_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	_start_game(custom_edit.text)


func _on_custom_edit_editing_toggled(_toggled_on: bool) -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
