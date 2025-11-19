class_name PlayerShip
extends AbstractShip


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.set_belonging(AbstractWeapon.Belonging.PLAYER)
