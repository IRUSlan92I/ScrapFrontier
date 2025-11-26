class_name AbstractShip
extends CharacterBody2D


const CANNON = preload("res://game/entities/weapons/cannon/cannon_weapon.tscn")
const GATLING = preload("res://game/entities/weapons/gatling/gatling_weapon.tscn")
const LASER = preload("res://game/entities/weapons/laser/laser_weapon.tscn")
const LAUNCHER = preload("res://game/entities/weapons/launcher/launcher_weapon.tscn")
const MINELAYER = preload("res://game/entities/weapons/minelayer/minelayer_weapon.tscn")
const PLASMA = preload("res://game/entities/weapons/plasma/plasma_weapon.tscn")
const RAILGUN = preload("res://game/entities/weapons/railgun/railgun_weapon.tscn")
const SHRAPNEL = preload("res://game/entities/weapons/shrapnel/shrapnel_weapon.tscn")
const TESLA = preload("res://game/entities/weapons/tesla/tesla_weapon.tscn")

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
@export_range(0, 1000) var mass : int = 0

@export_range(0, 360) var weapon_rotation : int = 0


var weapon_positions: Array[Vector2]


var _weapons : Array[AbstractWeapon]


func _ready() -> void:
	for slot in $WeaponSlots.get_children():
		if slot is Node2D:
			weapon_positions.append(slot.global_position - global_position)
	
	for pos in weapon_positions:
		var weapon : AbstractWeapon = WEAPONS.pick_random().instantiate()
		weapon.position = pos
		weapon.rotation_degrees = weapon_rotation
		add_child(weapon)
		_weapons.append(weapon)


func _physics_process(_delta: float) -> void:
	var was_collided := move_and_slide()
	if was_collided:
		for i in get_slide_collision_count():
			var collider := get_slide_collision(i).get_collider()
			if collider is AbstractShip:
				var other_ship := collider as AbstractShip
				var momentum := mass * velocity
				var collider_momentum := other_ship.mass * other_ship.velocity
				var total_mass := mass + other_ship.mass
				
				var new_velocity := (momentum + collider_momentum)/total_mass
				other_ship.velocity = new_velocity
				velocity = new_velocity
		
		var normal := get_wall_normal()
		velocity -= normal.abs() * velocity


func accelerate(direction: Vector2, delta: float) -> void:
	var accel : Vector2 = direction * acceleration * delta
	var decel : float = deceleration * delta
	
	velocity.x = _get_new_speed(accel.x, decel, velocity.x)
	velocity.y = _get_new_speed(accel.y, decel, velocity.y)

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


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
