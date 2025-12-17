class_name AbstractEnemyShip
extends AbstractShip


var is_on_screen : bool = false
var weapon_type : AbstractWeapon.Type = AbstractWeapon.Type.NONE
var enemy_data : EnemyData:
	set = _set_enemy_data


@onready var controller : EnemyController = $EnemyController


func _add_weapon(weapon: AbstractWeapon, weapon_position: Vector2) -> void:
	super._add_weapon(weapon, weapon_position)
	weapon.set_belonging(AbstractWeapon.Belonging.ENEMY)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_on_screen = false


func _set_enemy_data(data: EnemyData) -> void:
	enemy_data = data
	for weapon in _weapons:
		weapon.queue_free()
	_weapons.clear()
	
	var positions := weapon_positions.duplicate()
	if positions.size() == 3 and enemy_data.weapon_count == 2:
		positions.remove_at(0)
	
	for i in range(min(enemy_data.weapon_count, positions.size())):
		var weapon : AbstractWeapon = enemy_data.weapon.scene.instantiate()
		_add_weapon(weapon, weapon_positions[i])


func _create_weapon(weapon_id : String) -> AbstractWeapon:
	var weapon_scene : PackedScene = load(WEAPON_SCENES[weapon_id])
	var weapon : AbstractWeapon = weapon_scene.instantiate()
	weapon_type = weapon.type
	return weapon
