extends Control


signal continue_game
signal show_main_menu


@onready var pause_menu : Control = $PauseMenu
@onready var options : Control = $Options


func _ready() -> void:
	_show_menu(pause_menu)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
		_on_pause_menu_continue_game.call_deferred()


func _show_menu(menu: Control) -> void:
	var menus : Array[Control] = [ pause_menu, options ]
	
	for m in menus:
		m.hide()
		m.set_process_input(false)
	
	menu.show()
	menu.set_process_input(true)


func _on_pause_menu_continue_game() -> void:
	continue_game.emit()


func _on_pause_menu_show_main_menu() -> void:
	show_main_menu.emit()


func _on_pause_menu_show_options() -> void:
	_show_menu(options)


func _on_options_back() -> void:
	_show_menu(pause_menu)


func _on_visibility_changed() -> void:
	get_tree().paused = visible
