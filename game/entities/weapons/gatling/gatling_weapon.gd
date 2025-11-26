extends AbstractWeapon


@export var reloader : GatlingReloader


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	reloader.process(delta)


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	sprite.play(PREFIXES[_belonging] + IDLE_POSTFIX)


func shoot(ship_velocity: Vector2) -> bool:
	_can_shoot = reloader.can_shoot()
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		reloader.shoot()
	
	return is_shot
