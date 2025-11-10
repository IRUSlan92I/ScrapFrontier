class_name AbstractEnemyShip
extends AbstractShip


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.belonging = AbstractWeapon.Belonging.ENEMY
