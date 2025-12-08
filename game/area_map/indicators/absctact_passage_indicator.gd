class_name AbstractPassageIndicator
extends Node2D


@onready var active_texture : Sprite2D = $ActiveTexture
@onready var inactive_texture : Sprite2D = $InactiveTexture


func _ready() -> void:
	inactive_texture.hide()


func set_active(is_active: bool) -> void:
	active_texture.visible = is_active
	inactive_texture.visible = not is_active
