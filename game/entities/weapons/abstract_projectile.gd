class_name AbstractProjectile
extends Area2D


const PLAYER_LAYER = 2
const ENEMY_LAYER = 4
const PLAYER_PROJECTILE_LAYER = 8
const ENEMY_PROJECTILE_LAYER = 16


@export var damage : AbstractDamage
@export_range(0, 1000) var speed : int = 0


@onready var collision : CollisionShape2D = $CollisionShape2D


var direction : Vector2
var ship_velocity: Vector2

var collide_players: bool:
	set(value):
		collide_players = value
		_apply_collision_mask()

var collide_enemies: bool:
	set(value):
		collide_enemies = value
		_apply_collision_mask()


var _velocity: Vector2


func _ready() -> void:
	_velocity = direction.normalized() * speed + ship_velocity
	_update_collision_rotation(_velocity)
	
	_apply_collision_mask()


func _physics_process(delta: float) -> void:
	position += _velocity * delta


func _apply_collision_mask() -> void:
	if collide_players:
		collision_layer |= ENEMY_PROJECTILE_LAYER
		collision_mask |= PLAYER_LAYER
	else:
		collision_layer &= ~ENEMY_PROJECTILE_LAYER
		collision_mask &= ~PLAYER_LAYER
	
	if collide_enemies:
		collision_layer |= PLAYER_PROJECTILE_LAYER
		collision_mask |= ENEMY_LAYER
	else:
		collision_layer &= ~PLAYER_PROJECTILE_LAYER
		collision_mask &= ~ENEMY_LAYER


func _update_collision_rotation(velocity: Vector2) -> void:
	collision.rotation = velocity.angle() - 0.5 * PI


func _on_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	var health_component : Health = body.find_child("Health")
	if health_component and health_component.has_method("apply_damage"):
		health_component.apply_damage(damage)
		_process_hit_for_projectile(body)


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	queue_free()


func _get_nearest_foe(filter: Array[AbstractShip] = []) -> AbstractShip:
	var nearest_foe : AbstractShip = null
	var minimal_distance := 1000000
	
	for foe in _get_foes(filter):
		var distance := floori(position.distance_to(foe.position))
		if distance < minimal_distance:
			minimal_distance = distance
			nearest_foe = foe
	
	return nearest_foe


func _get_foes(filter: Array[AbstractShip] = []) -> Array[AbstractShip]:
	var foes : Array[AbstractShip] = []
	
	var flags_by_group : Dictionary[String, bool] = {
		"enemies": collide_enemies,
		"players": collide_players,
	}
	
	for group in flags_by_group:
		if not flags_by_group[group]: continue
		var nodes := get_tree().get_nodes_in_group(group)
		for node in nodes:
			if not node in filter:
				foes.append(node)
	
	return foes
