class_name AbstractEnemyShip
extends AbstractShip


var is_on_screen : bool = false

var enemy_data : EnemyData:
	set = _set_enemy_data


@onready var controller : EnemyController = $EnemyController


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_on_screen:
		shoot()


func weapon_type() -> AbstractWeapon.Type:
	return AbstractWeapon.Type.NONE if _weapons.is_empty() else _weapons[0].type


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
		var weapon_scene := enemy_data.weapon.enemy_scene
		var weapon : AbstractWeapon = weapon_scene.instantiate()
		_add_weapon(weapon, positions[i])
