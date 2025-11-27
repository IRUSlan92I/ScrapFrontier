extends Node


@onready var pause_screen : Control = $PauseScreen
@onready var game_over_screen : Control = $GameOverScreen


func _ready() -> void:
	pause_screen.hide()
	game_over_screen.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.show()
		get_tree().paused = true


func _on_pause_screen_continue_game() -> void:
	pause_screen.hide()


func _on_show_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/title_screen.tscn")


func _on_passage_player_died() -> void:
	game_over_screen.show()
