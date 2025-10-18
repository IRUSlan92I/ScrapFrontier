extends Node

signal show_main_menu


var _current_scene: Node
var _current_passage: Node


func _process(_delta: float) -> void:
    if Input.is_action_pressed("pause"):
        _show_pause_menu()




func _ready() -> void:
    _show_passage()


func _show_passage() -> void:
    if _current_scene != null:
        _current_scene.queue_free()
        
    if _current_passage == null:
        _current_passage = load("res://game/passage.tscn").instantiate()
        add_child(_current_passage)
    else:
        _current_passage.visible = true
    
    
func _show_pause_menu() -> void:
    if _current_scene != null:
        _current_scene.queue_free()
    if _current_passage != null:
        _current_passage.visible = false
    
    var scene : Node = load("res://menu/pause_menu.tscn").instantiate()
    add_child(scene)
    scene.continue_game.connect(_show_passage)
    scene.show_main_menu.connect(_show_main_menu)
    _current_scene = scene
    

func _show_main_menu() -> void:
    show_main_menu.emit()
