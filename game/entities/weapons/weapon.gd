class_name Weapon
extends Node2D


@export var damage : int
@export var bullet_per_shot : int
@export var sector_angle : int
#@export var Projectile : AbstractProjectile
@export var reloaders : Array[AbstractReloader]


@onready var sprite := $Sprite2D


func _init() -> void:
	#TEST
	var firerate_reloader := preload("res://game/entities/weapons/reloaders/firerate_reloader.gd").new()
	firerate_reloader.firerate = 600
	reloaders.append(firerate_reloader)
	add_child(firerate_reloader)
	
	var magazine_reloader := preload("res://game/entities/weapons/reloaders/magazine_reloader.gd").new()
	magazine_reloader.magazine_size = 300
	magazine_reloader.reload_time = 2
	reloaders.append(magazine_reloader)
	add_child(magazine_reloader)
	
	#var energy_reloader := preload("res://game/entities/weapons/reloaders/energy_reloader.gd").new()
	#energy_reloader.heat_capacity = 1000
	#energy_reloader.heat_per_shot = 25
	#energy_reloader.cooling_down_rate = 1000
	#reloaders.append(energy_reloader)
	#add_child(energy_reloader)


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(10, 7)
	sprite.texture = texture


func shoot() -> void:
	if not _can_shoot(): return
	print("shot")
	
	var projectile := preload("res://game/entities/weapons/projectiles/gatling_projectile.tscn").instantiate()
	projectile.direction = Vector2.RIGHT
	add_child(projectile)
	
	for reloader in reloaders:
		reloader.shoot()


func reload() -> void:
	for reloader in reloaders:
		reloader.reload()


func _can_shoot() -> bool:
	for reloader in reloaders:
		if not reloader.can_shoot():
			return false
	return true
