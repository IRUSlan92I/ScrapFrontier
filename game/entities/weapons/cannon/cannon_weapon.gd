extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var front_particles : GPUParticles2D = $ShotParticles/Front
@onready var left_particles : GPUParticles2D = $ShotParticles/Left
@onready var right_particles : GPUParticles2D = $ShotParticles/Right
@onready var shell_particles : GPUParticles2D = $ShellParticles
@onready var cooldown_timer : Timer = $CooldownTimer


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	_init_particles()
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func _init_particles() -> void:
	const FRONT_OFFSET_X = 12
	const SIDE_OFFSET_X = 6
	const SIDE_OFFSET_Y = 5
	const SHELL_OFFSET_X = -10
	const SHELL_OFFSET_Y = 2
	
	
	match _belonging:
		Belonging.PLAYER:
			front_particles.process_material.emission_shape_offset.x = FRONT_OFFSET_X
			front_particles.process_material.direction = Vector3.RIGHT
			
			left_particles.process_material.emission_shape_offset.x = SIDE_OFFSET_X
			left_particles.process_material.emission_shape_offset.y = -SIDE_OFFSET_Y
			left_particles.process_material.direction = Vector3.DOWN + Vector3.LEFT
			
			right_particles.process_material.emission_shape_offset.x = SIDE_OFFSET_X
			right_particles.process_material.emission_shape_offset.y = SIDE_OFFSET_Y
			right_particles.process_material.direction = Vector3.UP + Vector3.LEFT
			
			shell_particles.process_material.emission_shape_offset.x = SHELL_OFFSET_X
			shell_particles.process_material.emission_shape_offset.y = SHELL_OFFSET_Y
			shell_particles.process_material.direction = Vector3.UP
		Belonging.ENEMY:
			front_particles.process_material.emission_shape_offset.x = -FRONT_OFFSET_X
			front_particles.process_material.direction = Vector3.LEFT
			
			left_particles.process_material.emission_shape_offset.x = -SIDE_OFFSET_X
			left_particles.process_material.emission_shape_offset.y = -SIDE_OFFSET_Y
			left_particles.process_material.direction = Vector3.DOWN + Vector3.RIGHT
			
			right_particles.process_material.emission_shape_offset.x = -SIDE_OFFSET_X
			right_particles.process_material.emission_shape_offset.y = SIDE_OFFSET_Y
			right_particles.process_material.direction = Vector3.UP + Vector3.RIGHT
			
			shell_particles.process_material.emission_shape_offset.x = -SHELL_OFFSET_X
			shell_particles.process_material.emission_shape_offset.y = -SHELL_OFFSET_Y
			shell_particles.process_material.direction = Vector3.DOWN


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		sprite.play(PREFIXES[_belonging] + SHOT_POSTFIX)
		_can_shoot = false
		cooldown_timer.start()
		_restart_particles()
	
	return is_shot


func _restart_particles() -> void:
	front_particles.restart()
	left_particles.restart()
	right_particles.restart()
	shell_particles.restart()


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
