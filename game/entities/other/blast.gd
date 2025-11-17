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
	damage_dub.value = round(damage_dub.value * factor)
	return damage_dub


func _get_distance_to(body: Node2D) -> float:
	if not shape: return INF
	
	#TODO optimize by binary search
	for radius in range(shape.radius + 1):
		var query := PhysicsShapeQueryParameters2D.new()
		var circle_shape := CircleShape2D.new()
		circle_shape.radius = radius
		query.shape = circle_shape
		query.transform = Transform2D(0, global_position)
		query.collide_with_areas = false
		query.collide_with_bodies = true
		query.collision_mask = collision_mask
		query.exclude = [self]
		
		var space_state := get_world_2d().direct_space_state
		var results := space_state.intersect_shape(query)
		
		for result in results:
			if result["collider"] == body:
				return radius
	
	return INF


func _get_damage_factor(distance: float) -> float:
	if not shape: return 0.0
	
	var coef := distance / shape.radius
	if coef > 1:
		return 0.0
	return 1 - coef * coef * coef
