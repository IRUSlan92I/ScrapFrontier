extends Node

signal show_credits
signal show_main_menu

@onready var fullscreen_check := $%FullscreenCheckButton
@onready var window_factor := $%WindowFactorOptionButton


func _ready() -> void:
    _load_current_settings()


func _load_current_settings() -> void:
    fullscreen_check.button_pressed = SettingsManager.fullscreen()
    window_factor.selected = SettingsManager.window_factor()
    _update_window_factor_disabled()


func _update_window_factor_disabled() -> void:
    window_factor.disabled = SettingsManager.fullscreen()


func _on_fullscreen_check_button_toggled(toggled: bool) -> void:
    SettingsManager.set_fullscreen(toggled)
    _update_window_factor_disabled()


func _on_window_factor_option_button_item_selected(index: int) -> void:
    if !SettingsManager.fullscreen():
        SettingsManager.set_window_factor(index)


func _on_credits_button_pressed() -> void:
    show_credits.emit()


func _on_back_button_pressed() -> void:
    show_main_menu.emit()
