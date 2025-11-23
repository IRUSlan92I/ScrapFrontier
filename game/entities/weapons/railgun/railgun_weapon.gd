extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
		print(1, sprite.animation)
		_can_shoot = false
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.ends_with(SHOT_POSTFIX):
		sprite.play(PREFIXES[_belonging] + RELOAD_POSTFIX)
		print(PREFIXES[_belonging] + RELOAD_POSTFIX)
		print(2, sprite.animation)
	else:
		sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)
		print(3, sprite.animation)
		_can_shoot = true
