extends Control


@onready var continue_button := $%ContinueButton
@onready var main_menu_button := $%MainMenuButton


signal continue_game
signal show_main_menu


func _ready() -> void:
	_init_focus()
	_setup_neighbors()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	continue_button.grab_focus()


func _setup_neighbors() -> void:
	continue_button.focus_neighbor_top = main_menu_button.get_path()
	main_menu_button.focus_neighbor_bottom = continue_button.get_path()


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_main_menu_button_pressed() -> void:
	show_main_menu.emit()
