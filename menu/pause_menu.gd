extends Node

signal continue_game
signal show_main_menu


func _ready() -> void:
    _init_focus()
    _setup_neighbors()


func _init_focus() -> void:
    $%ContinueButton.grab_focus()


func _setup_neighbors() -> void:
   $%ContinueButton.focus_neighbor_top = $%MainMenuButton.get_path()
   $%MainMenuButton.focus_neighbor_bottom = $%ContinueButton.get_path()


func _on_continue_button_pressed() -> void:
    continue_game.emit()


func _on_main_menu_button_pressed() -> void:
    show_main_menu.emit()
