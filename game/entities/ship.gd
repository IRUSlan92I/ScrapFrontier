extends CharacterBody2D


@onready var sprite := $Sprite2D
@onready var colision := $CollisionShape2D


@export var size : Vector2:
	set(value):
		size = value
		if sprite and sprite.texture:
			sprite.texture.size = value
		if colision:
			colision.shape.radius = 0.9 * minf(size.x, size.y)/2
			colision.shape.height = 0.9 * maxf(size.x, size.y)
			colision.rotation = 0.0 if size.x < size.y else PI/2
	get:
		return size

@export var acceleration : int
@export var deceleration : int
@export var max_speed : int

@onready var weapons : Array[Weapon]:
	set(value):
		pass
	get:
		return weapons


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = size
	sprite.texture = texture
	
	const WEAPON = preload("res://game/entities/weapons/weapon.tscn")
	var weapons_by_offset := {
		8: WEAPON.instantiate(),
		-8: WEAPON.instantiate(),
	}
	for offset : int in weapons_by_offset:
		var weapon : Node2D = weapons_by_offset[offset]
		weapon.position = Vector2(0, offset)
		add_child(weapon)
		weapons.append(weapon)


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


func _get_new_speed(accel: float, decel: float, current_speed: float) -> float:
	if is_zero_approx(accel):
		if absf(current_speed) < decel:
			return 0.0
		return current_speed + (decel if current_speed < 0 else -decel)
	else:
		return current_speed + accel


func shoot(weapon: Node) -> void:
	if weapon in weapons:
		weapon.shoot()


func reload(weapon: Node) -> void:
	if weapon in weapons:
		weapon.reload()
