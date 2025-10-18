extends Node

signal show_main_menu


func _on_main_menu_button_pressed() -> void:
    show_main_menu.emit()
