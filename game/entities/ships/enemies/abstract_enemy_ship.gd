class_name AbstractEnemyShip
extends AbstractShip


var is_on_screen : bool = false
var weapon_type : AbstractWeapon.Type = AbstractWeapon.Type.NONE


@onready var controller : EnemyController = $EnemyController


func _ready() -> void:
	super._ready()
	
	var weapon_scene : PackedScene = WEAPONS.pick_random()
	for weapon_position in weapon_positions:
		var weapon : AbstractWeapon = weapon_scene.instantiate()
		weapon_type = weapon.type
		_add_weapon(weapon, weapon_position)


func _add_weapon(weapon: AbstractWeapon, weapon_position: Vector2) -> void:
	super._add_weapon(weapon, weapon_position)
	weapon.set_belonging(AbstractWeapon.Belonging.ENEMY)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_on_screen = false
