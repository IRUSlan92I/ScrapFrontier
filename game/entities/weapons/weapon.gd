extends Node2D


@export var damage : int
@export var firerate : int
@export var magazine_size : int
@export var reload_time : int
@export var bullet_velocity : int
@export var bullet_acceleration : int
@export var bullet_per_shot : int
@export var sector_angle : int
@export var distance : int
@export var heat_per_shot : int
@export var heat_capacity : int
@export var cooling_down_rate : int
@export var explosion_size : int


func _init() -> void:
#TEST
	firerate = 600
	magazine_size = 300
	reload_time = 2


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(10, 7)
	$Sprite2D.texture = texture


func shoot() -> void:
	if not _can_shoot(): return
	print("shoot")


func _can_shoot() -> bool:
	return true
