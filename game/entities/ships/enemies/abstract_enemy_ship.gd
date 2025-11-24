class_name AbstractEnemyShip
extends AbstractShip


@onready var controller : EnemyController = $EnemyController


var is_on_screen : bool = false


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.set_belonging(AbstractWeapon.Belonging.ENEMY)


func _on_enemy_controller_shoot() -> void:
	for weapon in _weapons:
		weapon.shoot(velocity)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_on_screen = false
