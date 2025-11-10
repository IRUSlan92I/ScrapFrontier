class_name PlayerShip
extends AbstractShip


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.belonging = AbstractWeapon.Belonging.PLAYER
