class_name AbstractShip
extends CharacterBody2D


@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D


@export_range(0, 250) var acceleration : int = 0
@export_range(0, 250) var deceleration : int = 0
@export_range(0, 250) var max_speed : int = 0

@export var weapon_positions: Array[Vector2]


var _weapons : Array[AbstractWeapon]


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
