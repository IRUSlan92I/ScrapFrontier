class_name CurrentSectorIndicator
extends Node2D


const ANIMATION = "animation"


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.play(ANIMATION)
