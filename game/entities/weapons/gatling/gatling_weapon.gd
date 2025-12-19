extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shot_particles : GPUParticles2D = $ShotParticles
@onready var shell_particles : GPUParticles2D = $ShellParticles


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
		shot_particles.restart()
		shell_particles.emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	_can_shoot = true
