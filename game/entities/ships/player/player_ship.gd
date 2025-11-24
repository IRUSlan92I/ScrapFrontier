class_name PlayerShip
extends AbstractShip


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.set_belonging(AbstractWeapon.Belonging.PLAYER)


func _on_player_controller_shoot(weapon_index: int) -> void:
	if weapon_index >= _weapons.size(): return
	
	_weapons[weapon_index].shoot(velocity)
