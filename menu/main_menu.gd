extends Node

signal continue_game
signal new_game
signal quit_game
signal show_options


func _on_continue_button_pressed() -> void:
    continue_game.emit()


func _on_start_button_pressed() -> void:
    new_game.emit()


func _on_options_button_pressed() -> void:
    show_options.emit()


func _on_quit_button_pressed() -> void:
    quit_game.emit()
