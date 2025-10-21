extends Node2D

@export var size : Vector2:
	set(value):
		size = value
		if $Sprite2D.texture:
			$Sprite2D.texture.size = value
	get:
		return size

@export var acceleration : int
@export var deceleration : int
@export var max_speed : int

var _velocity : Vector2


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = size
	$Sprite2D.texture = texture


func _process(delta: float) -> void:
	position += _velocity * delta


func accelerate(direction: Vector2, delta: float) -> void:
	var accel : Vector2 = direction * acceleration * delta
	var decel : float = deceleration * delta
	
	_velocity.x = _get_new_speed(accel.x, decel, _velocity.x)
	_velocity.y = _get_new_speed(accel.y, decel, _velocity.y)

	if _velocity.length() > max_speed:
		_velocity = _velocity.normalized() * max_speed


func _get_new_speed(accel: float, decel: float, current_speed: float) -> float:
	if is_zero_approx(accel):
		if absf(current_speed) < decel:
			return 0.0
		else:
			if current_speed < 0:
				return current_speed + decel
			else:
				return current_speed - decel
	else:
		return current_speed + accel
