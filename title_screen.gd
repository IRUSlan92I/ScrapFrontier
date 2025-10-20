extends Node

signal continue_game
signal new_game
signal quit_game

var _current_scene: Node


func _ready() -> void:
	_show_main_menu()


func _show_main_menu() -> void:
	if _current_scene != null:
		_current_scene.queue_free()
	
	var scene : Node = load("res://menu/main_menu.tscn").instantiate()
	add_child(scene)
	scene.continue_game.connect(_continue_game)
	scene.new_game.connect(_new_game)
	scene.show_options.connect(_show_options)
	scene.quit_game.connect(_quit_game)
	_current_scene = scene


func _continue_game() -> void:
	continue_game.emit()


func _new_game() -> void:
	new_game.emit()


func _quit_game() -> void:
	quit_game.emit()


func _show_options() -> void:
	if _current_scene != null:
		_current_scene.queue_free()
	
	var scene : Node = load("res://menu/options.tscn").instantiate()
	add_child(scene)
	scene.show_main_menu.connect(_show_main_menu)
	scene.show_credits.connect(_show_credits)
	_current_scene = scene


func _show_credits() -> void:
	if _current_scene != null:
		_current_scene.queue_free()
	
	var scene : Node = load("res://menu/credits.tscn").instantiate()
	add_child(scene)
	scene.show_main_menu.connect(_show_main_menu)
	_current_scene = scene
