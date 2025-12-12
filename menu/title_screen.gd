extends Control


@onready var main_menu : Control = $MainMenu
@onready var options : Control = $Options
@onready var credits : Control = $Credits


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_show_menu(main_menu)


func _show_menu(menu: Control) -> void:
	var menus : Array[Control] = [ main_menu, options, credits ]
	
	for m in menus:
		m.hide()
	
	menu.show()


func _on_main_menu_continue_game() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_main_menu_new_game() -> void:
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_main_menu_quit_game() -> void:
	get_tree().quit()


func _on_main_menu_show_options() -> void:
	_show_menu(options)


func _on_options_show_credits() -> void:
	_show_menu(credits)


func _on_options_back() -> void:
	_show_menu(main_menu)


func _on_credits_back() -> void:
	_show_menu(options)
