class_name AbstractSectorIndicator
extends Node2D


@onready var active_sprite : Sprite2D = $ActiveSprite
@onready var inactive_sprite : Sprite2D = $InactiveSprite


func _ready() -> void:
	inactive_sprite.hide()


func set_active(is_active: bool) -> void:
	active_sprite.visible = is_active
	inactive_sprite.visible = not is_active
