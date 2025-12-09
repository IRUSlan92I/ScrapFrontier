class_name SelectedSectorIndicator
extends Node2D


const ANIMATION = "animation"


@onready var active_sprite : AnimatedSprite2D = $ActiveSprite
@onready var inactive_sprite : AnimatedSprite2D = $InactiveSprite


func _ready() -> void:
	active_sprite.play(ANIMATION)
	inactive_sprite.play(ANIMATION)
	inactive_sprite.hide()


func set_active(is_active: bool) -> void:
	active_sprite.visible = is_active
	inactive_sprite.visible = not is_active
