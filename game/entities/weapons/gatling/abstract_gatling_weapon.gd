class_name AbstractGatlingWeapon
extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shot_particles : GPUParticles2D = $ShotParticles
@onready var shell_particles : GPUParticles2D = $ShellParticles


func _ready() -> void:
	sprite.play(IDLE_ANIMATION)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		SoundManager.play_sfx_stream(SoundManager.sfx_weapon_gatling_shot, global_position)
		sprite.play(SHOT_ANIMATION)
		shot_particles.restart()
		shell_particles.emit_particle(Transform2D(), Vector2(), Color(), Color(), 0)
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	_can_shoot = true
	sprite.play(IDLE_ANIMATION)
