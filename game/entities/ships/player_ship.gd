class_name PlayerShip
extends AbstractShip


func _ready() -> void:
	@warning_ignore("unused_local_constant")
	const CANNON = preload("res://game/entities/weapons/cannon/cannon.tscn")
	@warning_ignore("unused_local_constant")
	const GATLING = preload("res://game/entities/weapons/gatling/gatling.tscn")
	@warning_ignore("unused_local_constant")
	const LASER = preload("res://game/entities/weapons/laser/laser.tscn")
	@warning_ignore("unused_local_constant")
	const LAUNCHER = preload("res://game/entities/weapons/launcher/launcher.tscn")
	@warning_ignore("unused_local_constant")
	const MINELAYER = preload("res://game/entities/weapons/minelayer/minelayer.tscn")
	@warning_ignore("unused_local_constant")
	const PLASMA = preload("res://game/entities/weapons/plasma/plasma.tscn")
	@warning_ignore("unused_local_constant")
	const RAILGUN = preload("res://game/entities/weapons/railgun/railgun.tscn")
	@warning_ignore("unused_local_constant")
	const SHRAPNEL = preload("res://game/entities/weapons/shrapnel/shrapnel.tscn")
	@warning_ignore("unused_local_constant")
	const TESLA = preload("res://game/entities/weapons/tesla/tesla.tscn")
	
	var weapons := [
		GATLING.instantiate(),
		RAILGUN.instantiate(),
	]
	
	for index in weapons.size():
		var weapon : Node2D = weapons[index]
		if index < weapon_positions.size():
			weapon.position = weapon_positions[index]
		add_child(weapons[index])
		_weapons.append(weapon)
