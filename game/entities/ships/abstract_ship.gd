class_name AbstractShip
extends CharacterBody2D


const CANNON = preload("res://game/entities/weapons/cannon/cannon.tscn")
const GATLING = preload("res://game/entities/weapons/gatling/gatling.tscn")
const LASER = preload("res://game/entities/weapons/laser/laser.tscn")
const LAUNCHER = preload("res://game/entities/weapons/launcher/launcher.tscn")
const MINELAYER = preload("res://game/entities/weapons/minelayer/minelayer.tscn")
const PLASMA = preload("res://game/entities/weapons/plasma/plasma.tscn")
const RAILGUN = preload("res://game/entities/weapons/railgun/railgun.tscn")
const SHRAPNEL = preload("res://game/entities/weapons/shrapnel/shrapnel.tscn")
const TESLA = preload("res://game/entities/weapons/tesla/tesla.tscn")

const WEAPONS := [
	CANNON, GATLING, LASER,
	LAUNCHER, MINELAYER, PLASMA,
	RAILGUN, SHRAPNEL, TESLA,
]


signal destroyed


@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D


@export_range(0, 250) var acceleration : int = 0
@export_range(0, 250) var deceleration : int = 0
@export_range(0, 250) var max_speed : int = 0

@export var weapon_positions: Array[Vector2]


var _weapons : Array[AbstractWeapon]


func _ready() -> void:
	for pos in weapon_positions:
		var weapon : AbstractWeapon = WEAPONS.pick_random().instantiate()
		weapon.position = pos
		add_child(weapon)
		_weapons.append(weapon)


func _physics_process(_delta: float) -> void:
	var was_collided := move_and_slide()
	if was_collided:
		var normal := get_wall_normal()
		velocity -= normal.abs() * velocity


func accelerate(direction: Vector2, delta: float) -> void:
	var accel : Vector2 = direction * acceleration * delta
	var decel : float = deceleration * delta
	
	velocity.x = _get_new_speed(accel.x, decel, velocity.x)
	velocity.y = _get_new_speed(accel.y, decel, velocity.y)

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


func shoot(weapon_index: int) -> void:
	if weapon_index >= _weapons.size(): return
	
	_weapons[weapon_index].shoot(velocity)


func reload(weapon_index: int) -> void:
	if weapon_index >= _weapons.size(): return
	
	_weapons[weapon_index].reload()


func _get_new_speed(accel: float, decel: float, current_speed: float) -> float:
	if is_zero_approx(accel):
		if absf(current_speed) < decel:
			return 0.0
		return current_speed + (decel if current_speed < 0 else -decel)
	else:
		return current_speed + accel


func _on_health_depleted() -> void:
	queue_free()
	destroyed.emit()
