class_name Passage

extends Node2D

var _paused : bool = false


func set_paused(paused: bool) -> void:
    _paused = paused


func is_paused() -> bool:
    return _paused
