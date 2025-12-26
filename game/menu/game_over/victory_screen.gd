extends Control


signal show_main_menu


@onready var main_menu_button : Button = $%MainMenuButton
@onready var button_focus_timer : Timer = $ButtonFocusTimer


func _on_timer_timeout() -> void:
	main_menu_button.grab_focus()


func _on_main_menu_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	show_main_menu.emit()


func _on_visibility_changed() -> void:
	if visible and button_focus_timer:
		button_focus_timer.start()
