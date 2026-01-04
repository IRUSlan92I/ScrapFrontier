class_name AbstractCannonWeapon
extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var front_particles : GPUParticles2D = $ShotParticles/Front
@onready var left_particles : GPUParticles2D = $ShotParticles/Left
@onready var right_particles : GPUParticles2D = $ShotParticles/Right
@onready var shell_particles : GPUParticles2D = $ShellParticles
@onready var cooldown_timer : Timer = $CooldownTimer


func _ready() -> void:
	sprite.play(IDLE_ANIMATION)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		SoundManager.play_sfx_stream(SoundManager.sfx_weapon_cannon_shot, global_position)
		sprite.play(SHOT_ANIMATION)
		cooldown_timer.start()
		front_particles.restart()
		left_particles.restart()
		right_particles.restart()
		shell_particles.emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play(IDLE_ANIMATION)


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
