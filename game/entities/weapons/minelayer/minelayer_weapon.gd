extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)
	_can_shoot = true
