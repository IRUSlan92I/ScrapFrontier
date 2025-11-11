extends Node


const Passage = preload("res://game/passage.tscn")
const PauseMenu = preload("res://menu/pause_menu.tscn")


var _pause_menu: Node
var _current_passage: Node


func _ready() -> void:
	_current_passage = Passage.instantiate()
	add_child(_current_passage)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_pause_game()


func _create_pause_menu() -> void:
	_pause_menu = PauseMenu.instantiate()
	add_child(_pause_menu)
	_pause_menu.continue_game.connect(_unpause_game)
	_pause_menu.show_main_menu.connect(_show_title_screen)


func _pause_game() -> void:
	get_tree().paused = true
	_create_pause_menu.call_deferred()


func _unpause_game() -> void:
	get_tree().paused = false
	_pause_menu.queue_free()


func _show_title_screen() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/title_screen.tscn")
