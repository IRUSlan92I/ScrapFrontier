extends Node


signal show_main_menu


@onready var main_menu_button := $%MainMenuButton


func _ready() -> void:
	main_menu_button.grab_focus()


func _on_main_menu_button_pressed() -> void:
	show_main_menu.emit()
