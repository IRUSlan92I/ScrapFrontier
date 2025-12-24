extends Control


@onready var main_menu : Control = $%MainMenu
@onready var options : Control = $%Options
@onready var credits : Control = $%Credits
@onready var seed_selection : Control = $%SeedSelection


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_show_menu(main_menu)


func _show_menu(menu: Control) -> void:
	var menus : Array[Control] = [ main_menu, options, credits, seed_selection ]
	
	for m in menus:
		m.hide()
	
	menu.show()


func _on_main_menu_continue_game() -> void:
	get_tree().change_scene_to_file("res://game/entities/world/game.tscn")


func _on_main_menu_new_game() -> void:
	_show_menu(seed_selection)


func _on_main_menu_quit_game() -> void:
	get_tree().quit()


func _on_main_menu_show_options() -> void:
	_show_menu(options)


func _on_main_menu_show_credits() -> void:
	_show_menu(credits)


func _on_credits_back() -> void:
	_show_menu(main_menu)


func _show_main_menu() -> void:
	_show_menu(main_menu)
