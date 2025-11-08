class_name AbstractWeapon
extends Node2D


enum Belonging { PLAYER, ENEMY }


@export_range(1, 100) var bullet_per_shot : int = 1
@export_range(0, 360) var sector_angle : int = 0

@export var Projectile : PackedScene
@export var reloaders : Array[AbstractReloader]


var belonging: Belonging


var _reloaders : Array[AbstractReloader]


func _ready() -> void:
	for reloader in reloaders:
		_reloaders.append(reloader.duplicate())


func _physics_process(delta: float) -> void:
	for reloader in _reloaders:
		reloader.process(delta)


func shoot(ship_velocity: Vector2) -> void:
	if not _can_shoot(): return
	
	for i in range(bullet_per_shot):
		var projectile := _create_projectile(ship_velocity)
		get_tree().current_scene.add_child(projectile)
	
	for reloader in _reloaders:
		reloader.shoot()


func _create_projectile(ship_velocity: Vector2) -> Node:
	var projectile : AbstractProjectile = Projectile.instantiate()
	projectile.global_position = global_position
	projectile.ship_velocity = ship_velocity
	
	match belonging:
		Belonging.PLAYER:
			projectile.direction = Vector2.RIGHT
			projectile.collide_enemies = true
			projectile.rotation_degrees = 90
		Belonging.ENEMY:
			projectile.direction = Vector2.LEFT
			projectile.collide_player = true
			projectile.rotation_degrees = -90
	
	if sector_angle > 0:
		var sector_rad := deg_to_rad(sector_angle)
		var random_angle := randfn(0.0, sector_rad / 6.0)
		projectile.direction = projectile.direction.rotated(random_angle)
	
	return projectile


func reload() -> void:
	for reloader in _reloaders:
		reloader.reload()


func _can_shoot() -> bool:
	for reloader in _reloaders:
		if not reloader.can_shoot():
			return false
	return true
