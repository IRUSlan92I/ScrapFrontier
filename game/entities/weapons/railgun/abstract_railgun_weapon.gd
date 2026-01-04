class_name AbstractRailgunWeapon
extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.play(IDLE_ANIMATION)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		SoundManager.play_sfx_stream(SoundManager.sfx_weapon_railgun_shot, global_position)
		sprite.play(SHOT_ANIMATION)
	
	return is_shot


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == SHOT_ANIMATION:
		sprite.play(RELOAD_ANIMATION)
	else:
		sprite.play(IDLE_ANIMATION)
		_can_shoot = true
