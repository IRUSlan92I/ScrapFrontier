extends Control


signal show_credits
signal back


@onready var fullscreen_button := $%FullscreenCheckButton
@onready var window_factor_button := $%WindowFactorOptionButton
@onready var credits_button := $%CreditsButton
@onready var back_button := $%BackButton


func _ready() -> void:
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	fullscreen_button.grab_focus()


func _setup_neighbors() -> void:
	credits_button.focus_neighbor_left = back_button.get_path()
	back_button.focus_neighbor_right = credits_button.get_path()


func _load_current_settings() -> void:
	fullscreen_button.button_pressed = SettingsManager.fullscreen
	window_factor_button.selected = SettingsManager.window_factor
	_update_window_factor_disabled()


func _update_window_factor_disabled() -> void:
	window_factor_button.disabled = SettingsManager.fullscreen


func _on_fullscreen_check_button_toggled(toggled: bool) -> void:
	SettingsManager.fullscreen = toggled
	_update_window_factor_disabled()


func _on_window_factor_option_button_item_selected(index: int) -> void:
	if not SettingsManager.fullscreen:
		SettingsManager.window_factor = index


func _on_credits_button_pressed() -> void:
	show_credits.emit()


func _on_back_button_pressed() -> void:
	back.emit()
