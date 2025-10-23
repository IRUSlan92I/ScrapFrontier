extends CharacterBody2D


const Weapon = preload("res://game/entities/weapon.tscn")


@export var size : Vector2:
	set(value):
		size = value
		if $Sprite2D.texture:
			$Sprite2D.texture.size = value
		$CollisionShape2D.shape.radius = 0.9 * minf(size.x, size.y)/2
		$CollisionShape2D.shape.height = 0.9 * maxf(size.x, size.y)
		$CollisionShape2D.rotation = 0.0 if size.x < size.y else PI/2
	get:
		return size

@export var acceleration : int
@export var deceleration : int
@export var max_speed : int

@onready var weapons : Array:
	set(value):
		pass
	get:
		return weapons


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = size
	$Sprite2D.texture = texture
	
	var weapons_by_offset := {
		8: Weapon.instantiate(),
		-8: Weapon.instantiate(),
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
