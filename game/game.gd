extends Node

signal show_main_menu

var _pause_menu: Node
var _current_passage: Node


func _ready() -> void:
	_current_passage = load("res://game/passage.tscn").instantiate()
	add_child(_current_passage)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_game()
	

func _create_pause_menu() -> void:
	_pause_menu = load("res://menu/pause_menu.tscn").instantiate()
	add_child(_pause_menu)
	_pause_menu.continue_game.connect(_unpause_game)
	_pause_menu.show_main_menu.connect(_show_main_menu)
	

func _pause_game() -> void:
	get_tree().paused = true
	_create_pause_menu.call_deferred()
	

func _unpause_game() -> void:
	get_tree().paused = false
	_pause_menu.queue_free()
	

func _show_main_menu() -> void:
	get_tree().paused = false
	show_main_menu.emit()
