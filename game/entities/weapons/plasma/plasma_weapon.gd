extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer : Timer = $CooldownTimer


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
		_can_shoot = false
		cooldown_timer.start()
	
	return is_shot


func _get_projectile_position() -> Vector2:
	var projectile_position : Vector2
	
	match _belonging:
		Belonging.PLAYER:
			projectile_position = Vector2(-5, 2)
		Belonging.ENEMY:
			projectile_position = Vector2(5, -2)
	
	return projectile_position


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(PREFIXES[_belonging] + RELOAD_POSTFIX)


func _on_cooldown_timer_timeout() -> void:
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)
	_can_shoot = true
