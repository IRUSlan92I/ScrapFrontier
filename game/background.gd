class_name Background
extends Node2D


@onready var paralax_1 : Parallax2D = $Parallax1
@onready var paralax_2 : Parallax2D = $Parallax2
@onready var paralax_3 : Parallax2D = $Parallax3


func _ready() -> void:
	paralax_1.scroll_offset.x = randf_range(1, paralax_1.repeat_size.x)
	paralax_2.scroll_offset.x = randf_range(1, paralax_2.repeat_size.x)
	paralax_3.scroll_offset.x = randf_range(1, paralax_3.repeat_size.x)
