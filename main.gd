extends Node

var _current_scene: Node


func _ready() -> void:
	_show_main_menu()


func _show_main_menu() -> void:
	if _current_scene != null:
		_current_scene.queue_free()
	
	var scene : Node = load("res://title_screen.tscn").instantiate()
	add_child(scene)
	scene.continue_game.connect(_continue_game)
	scene.new_game.connect(_new_game)
	scene.quit_game.connect(_quit)
	_current_scene = scene


func _continue_game() -> void:
	print("continue_game")


func _new_game() -> void:
	if _current_scene != null:
		_current_scene.queue_free()
	
	var scene : Node = load("res://game/game.tscn").instantiate()
	add_child(scene)
	scene.show_main_menu.connect(_show_main_menu)
	_current_scene = scene


func _quit() -> void:
	get_tree().quit()
