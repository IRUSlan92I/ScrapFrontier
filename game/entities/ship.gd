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


func accelerate(value: Vector2) -> void:
	_velocity += value
	_velocity = _velocity.clamp(Vector2(-max_speed, -max_speed), Vector2(max_speed, max_speed))


func decelerate(value: float) -> void:
	var current_speed := _velocity.length()
	
	if current_speed <= 0:
		_velocity = Vector2.ZERO
		return
	
	var new_speed := current_speed - value
	if new_speed < 0:
		new_speed = 0
	
	_velocity = _velocity.normalized() * new_speed
