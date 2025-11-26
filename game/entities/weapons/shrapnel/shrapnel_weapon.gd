extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer : Timer = $CooldownTimer
@onready var shot_particles : GPUParticles2D = $ShotParticles
@onready var shell_particles : GPUParticles2D = $ShellParticles


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
		_can_shoot = false
		cooldown_timer.start()
		_restart_particles()
	
	return is_shot


func _restart_particles() -> void:
	shot_particles.restart()
	shell_particles.restart()


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
