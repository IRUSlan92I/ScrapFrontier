class_name AbstractEnemyShip
extends AbstractShip


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.set_belonging(AbstractWeapon.Belonging.ENEMY)
