class_name Blast
extends Area2D


@export var damage : AbstractDamage
@export var shape : CircleShape2D


const FALLOFF_FACTOR = 3


@onready var collision : CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	if collision and shape:
		collision.shape = shape


func get_damage_to(body: Node2D) -> AbstractDamage:
	var distance := _get_distance_to(body)
	var damage_dub := damage.duplicate()
	
	var factor := _get_damage_factor(distance)
	damage_dub.value = damage_dub.value * factor
	
	return damage_dub


func _get_distance_to(body: Node2D) -> float:
	return global_position.distance_to(body.global_position)


func _get_damage_factor(distance: float) -> float:
	if not shape: return 0.0
	
	var coef := distance / shape.radius
	if coef > 1:
		return 0.0
	return 1 - coef * coef * coef
