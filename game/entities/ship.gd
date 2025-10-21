extends CharacterBody2D

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

#var _velocity : Vector2


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = size
	$Sprite2D.texture = texture


func _physics_process(_delta: float) -> void:
	var was_collided := move_and_slide()
	if was_collided:
		var normal := get_wall_normal()
		velocity -= normal.abs() * velocity
	print(was_collided, get_wall_normal(), velocity)


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
