extends Node


signal continue_game
signal new_game
signal quit_game
signal show_options


func _ready() -> void:
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	if $%ContinueButton.disabled:
		$%StartButton.grab_focus()
	else:
		$%ContinueButton.grab_focus()


func _setup_neighbors() -> void:
	if $%ContinueButton.disabled:
		$%ContinueButton.focus_neighbor_top = ""
		$%StartButton.focus_neighbor_top = $%QuitButton.get_path()
		$%QuitButton.focus_neighbor_bottom = $%StartButton.get_path()
	else:
		$%ContinueButton.focus_neighbor_top = $%QuitButton.get_path()
		$%StartButton.focus_neighbor_top = ""
		$%QuitButton.focus_neighbor_bottom = $%ContinueButton.get_path()


func _on_continue_button_pressed() -> void:
	continue_game.emit()


func _on_start_button_pressed() -> void:
	new_game.emit()


func _on_options_button_pressed() -> void:
	show_options.emit()


func _on_quit_button_pressed() -> void:
	quit_game.emit()
