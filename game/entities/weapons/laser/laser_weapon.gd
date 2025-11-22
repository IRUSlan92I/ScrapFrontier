extends AbstractWeapon


@onready var idle_sprite : AnimatedSprite2D = $IdleAnimatedSprite
@onready var firing_sprite : AnimatedSprite2D = $FiringAnimatedSprite
@onready var cooldown_timer : Timer = $CooldownTimer


func _ready() -> void:
	_switch_sprite(false)


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	idle_sprite.play(PREFIXES[_belonging])
	firing_sprite.play(PREFIXES[_belonging])


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		_switch_sprite(true)
		cooldown_timer.start()
	
	return is_shot


func _on_cooldown_timer_timeout() -> void:
		_can_shoot = true
		_switch_sprite(false)


func _switch_sprite(firing: bool) -> void:
	if firing:
		idle_sprite.hide()
		firing_sprite.show()
	else:
		idle_sprite.show()
		firing_sprite.hide()
