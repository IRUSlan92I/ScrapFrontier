class_name ProjectileMover
extends Node


signal destroyed


@export var damage : int
@export var speed : int
@export var direction : Vector2
@export var acceleration : int
@export var max_distance : int
@export var max_livetime : int


var velocity : Vector2:
	set(value):
		pass
	get:
		return _velocity

var _velocity : Vector2
var _traveled_distance: float
var _livetime: float


func _ready() -> void:
	_velocity = direction.normalized() * speed


func process_acceleration(delta: float) -> void:
	var current_acceleration := acceleration * delta
	if current_acceleration > 0:
		_velocity += _velocity.normalized() * current_acceleration
	elif current_acceleration < 0:
		if _velocity.length() > current_acceleration:
			_velocity += _velocity.normalized() * current_acceleration
		else:
			_velocity = Vector2.ZERO


func process_distance(delta: float) -> void:
	_traveled_distance += _velocity.length() * delta
	if max_distance > 0 and _traveled_distance > max_distance:
		destroyed.emit()


func process_livetime(delta: float) -> void:
	_livetime += delta
	if _livetime > max_livetime:
		destroyed.emit()
