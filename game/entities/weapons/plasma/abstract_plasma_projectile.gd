class_name AbstractPlasmaProjectile
extends AbstractDirectHitProjectile


const ANIMATION_NAME = "default"


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	super._ready()
	sprite.play(ANIMATION_NAME)
