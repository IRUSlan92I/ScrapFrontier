class_name AbstractWeapon
extends Node2D


enum Belonging { PLAYER, ENEMY }


@export var belonging: Belonging

@export var damage : int
@export var bullet_per_shot : int
@export var sector_angle : int
@export var Projectile : PackedScene
@export var reloaders : Array[AbstractReloader]


var _reloaders : Array[AbstractReloader]


func _ready() -> void:
	for reloader in reloaders:
		_reloaders.append(reloader.duplicate())


func _physics_process(delta: float) -> void:
	for reloader in _reloaders:
		reloader.process(delta)


func shoot() -> void:
	if not _can_shoot(): return
	
	var projectile := Projectile.instantiate()
	
	match belonging:
		Belonging.PLAYER:
			projectile.direction = Vector2.RIGHT
			projectile.collide_enemies = true
		Belonging.ENEMY:
			projectile.direction = Vector2.LEFT
			projectile.collide_player = true
	
	add_child(projectile)
	
	for reloader in _reloaders:
		reloader.shoot()


func reload() -> void:
	for reloader in _reloaders:
		reloader.reload()


func _can_shoot() -> bool:
	for reloader in _reloaders:
		if not reloader.can_shoot():
			return false
	return true
