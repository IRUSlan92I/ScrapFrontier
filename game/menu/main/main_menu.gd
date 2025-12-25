extends Control


signal continue_game
signal new_game
signal show_options
signal show_credits
signal quit_game


@onready var continue_button := $%ContinueButton
@onready var start_button := $%StartButton
@onready var quit_button := $%QuitButton


func _ready() -> void:
	_init_focus()
	_setup_neighbors()
	_update_continue_button()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	_init_focus()
	_setup_neighbors()
	_update_continue_button()


func _update_continue_button() -> void:
	continue_button.disabled = SaveManager.game_data.game_seed.is_empty()


func _init_focus() -> void:
	if continue_button.disabled:
		start_button.grab_focus()
	else:
		continue_button.grab_focus()


func _setup_neighbors() -> void:
	if continue_button.disabled:
		continue_button.focus_neighbor_top = ""
		start_button.focus_neighbor_top = quit_button.get_path()
		quit_button.focus_neighbor_bottom = start_button.get_path()
	else:
		continue_button.focus_neighbor_top = quit_button.get_path()
		start_button.focus_neighbor_top = ""
		quit_button.focus_neighbor_bottom = continue_button.get_path()


func _on_continue_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	continue_game.emit()


func _on_start_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	new_game.emit()


func _on_options_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	show_options.emit()


func _on_credits_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	show_credits.emit()


func _on_quit_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_decline)
	quit_game.emit()
