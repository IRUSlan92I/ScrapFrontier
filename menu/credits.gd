extends Node

signal show_main_menu


func _ready() -> void:
    $%MainMenuButton.grab_focus()
    

func _on_main_menu_button_pressed() -> void:
    show_main_menu.emit()
