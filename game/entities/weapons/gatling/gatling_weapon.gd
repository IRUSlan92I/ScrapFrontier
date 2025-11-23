extends AbstractWeapon


@export var reloader : GatlingReloader


func _physics_process(delta: float) -> void:
	reloader.process(delta)


func shoot(ship_velocity: Vector2) -> bool:
	_can_shoot = reloader.can_shoot()
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		reloader.shoot()
	
	return is_shot
