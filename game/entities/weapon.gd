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


@onready var _firerate_delay : float = 60.0 / firerate
@onready var _firerate_delay_tenth : float = _firerate_delay / 10

@onready var _bullets_in_magazine : int = magazine_size if magazine_size > 0 else -1

@onready var _reload_time_tenth : float = reload_time / 10.0


var _firerate_cooldown : float
var _reload_cooldown : float

var random := RandomNumberGenerator.new()


func _init() -> void:
#TEST
	firerate = 600
	magazine_size = 300
	reload_time = 2


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(10, 7)
	$Sprite2D.texture = texture


func _process(delta: float) -> void:
	if _firerate_cooldown > 0:
		_firerate_cooldown -= delta
	if _reload_cooldown > 0:
		_reload_cooldown -= delta
	
	if _bullets_in_magazine == 0 and _reload_cooldown <= 0:
		_bullets_in_magazine = magazine_size


func shoot() -> void:
	if not _can_shoot(): return
	
	var random_firerate_delay := random.randf_range(-_firerate_delay_tenth, _firerate_delay_tenth)
	_firerate_cooldown = _firerate_delay + random_firerate_delay
	
	if _bullets_in_magazine > 0:
		_bullets_in_magazine -= 1
	
	if _bullets_in_magazine == 0:
		var random_reload_delay := random.randf_range(-_reload_time_tenth, _reload_time_tenth)
		_reload_cooldown = reload_time + random_reload_delay
	
	print("shoot")


func _can_shoot() -> bool:
	if _firerate_cooldown > 0: return false
	
	if _reload_cooldown > 0: return false
	
	return true
