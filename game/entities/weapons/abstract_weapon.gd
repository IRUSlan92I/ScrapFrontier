class_name AbstractWeapon
extends Node2D


enum Belonging { PLAYER, ENEMY }


@export_range(1, 100) var bullet_per_shot : int = 1
@export_range(0, 360) var sector_angle : int = 0

@export var Projectile : PackedScene
@export var reloaders : Array[AbstractReloader]


const PREFIXES := {
	Belonging.PLAYER: "player",
	Belonging.ENEMY: "enemy",
}

const SHOT_POSTFIX = "_shot"
const IDLE_POSTFIX = "_idle"


var _belonging: Belonging
var _current_projectile_position := 0
var _can_shoot := true


func _physics_process(delta: float) -> void:
	for reloader in reloaders:
		reloader.process(delta)


func set_belonging(belonging: Belonging) -> void:
	_belonging = belonging


func shoot(ship_velocity: Vector2) -> bool:
	if not _can_shoot or not _reloaders_can_shoot(): return false
	
	for i in range(bullet_per_shot):
		var projectile := _create_projectile(ship_velocity)
		
		projectile.global_position = global_position + _get_projectile_position()
		
		get_tree().current_scene.add_child(projectile)
	
	for reloader in reloaders:
		reloader.shoot()
	
	return true


func _get_projectile_position() -> Vector2:
	return Vector2.ZERO


func _create_projectile(ship_velocity: Vector2) -> AbstractProjectile:
	var projectile : AbstractProjectile = Projectile.instantiate()
	projectile.global_position = global_position
	projectile.ship_velocity = ship_velocity
	
	match _belonging:
		Belonging.PLAYER:
			projectile.direction = Vector2.RIGHT
			projectile.collide_enemies = true
		Belonging.ENEMY:
			projectile.direction = Vector2.LEFT
			projectile.collide_players = true
	
	if sector_angle > 0:
		var sector_rad := deg_to_rad(sector_angle)
		var random_angle := randfn(0.0, sector_rad / 6.0)
		projectile.direction = projectile.direction.rotated(random_angle)
	
	return projectile


func reload() -> void:
	for reloader in reloaders:
		reloader.reload()


func _reloaders_can_shoot() -> bool:
	for reloader in reloaders:
		if not reloader.can_shoot():
			return false
	return true
