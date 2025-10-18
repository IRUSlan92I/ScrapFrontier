extends Node

signal continue_game
signal show_main_menu


func _on_continue_button_pressed() -> void:
    continue_game.emit()


func _on_main_menu_button_pressed() -> void:
    show_main_menu.emit()
