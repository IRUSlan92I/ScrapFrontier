extends Node

signal show_main_menu


var _pause_menu: PauseMenu
var _current_passage: Passage

var _show_pause_menu: bool = false


func _ready() -> void:
    _current_passage = load("res://game/passage.tscn").instantiate()
    add_child(_current_passage)
    
    
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause") and not _current_passage.is_paused():
        _pause_game()


func _process(_delta: float) -> void:
    if _show_pause_menu:
        _pause_menu = load("res://menu/pause_menu.tscn").instantiate()
        add_child(_pause_menu)
        _pause_menu.continue_game.connect(_unpause_game)
        _pause_menu.show_main_menu.connect(_show_main_menu)
        _show_pause_menu = false


func _pause_game() -> void:
    _current_passage.set_paused(true)
    _current_passage.visible = false
        
    _show_pause_menu = true
    


func _unpause_game() -> void:
    _current_passage.set_paused(false)
    _current_passage.visible = true
        
    _pause_menu.queue_free()
    

func _show_main_menu() -> void:
    show_main_menu.emit()
