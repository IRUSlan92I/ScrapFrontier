extends Node


signal show_credits
signal show_main_menu


func _ready() -> void:
	_load_current_settings()
	_init_focus()
	_setup_neighbors()
	

func _init_focus() -> void:
	$%FullscreenCheckButton.grab_focus()


func _setup_neighbors() -> void:
	$%CreditsButton.focus_neighbor_left = $%BackButton.get_path()
	$%BackButton.focus_neighbor_right = $%CreditsButton.get_path()


func _load_current_settings() -> void:
	$%FullscreenCheckButton.button_pressed = SettingsManager.fullscreen
	$%WindowFactorOptionButton.selected = SettingsManager.window_factor
	_update_window_factor_disabled()


func _update_window_factor_disabled() -> void:
	$%WindowFactorOptionButton.disabled = SettingsManager.fullscreen


func _on_fullscreen_check_button_toggled(toggled: bool) -> void:
	SettingsManager.fullscreen = toggled
	_update_window_factor_disabled()


func _on_window_factor_option_button_item_selected(index: int) -> void:
	if not SettingsManager.fullscreen:
		SettingsManager.window_factor = index


func _on_credits_button_pressed() -> void:
	show_credits.emit()


func _on_back_button_pressed() -> void:
	show_main_menu.emit()
