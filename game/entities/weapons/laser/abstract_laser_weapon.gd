class_name AbstractLaserWeapon
extends AbstractWeapon


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer : Timer = $CooldownTimer


func _ready() -> void:
	sprite.play(SHOT_ANIMATION)


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		cooldown_timer.start()
	
	return is_shot


func _on_cooldown_timer_timeout() -> void:
		_can_shoot = true
