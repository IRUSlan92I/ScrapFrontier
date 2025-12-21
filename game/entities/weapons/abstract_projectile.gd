class_name AbstractProjectile
extends Area2D


const PLAYER_LAYER = 2
const ENEMY_LAYER = 4
const PLAYER_PROJECTILE_LAYER = 8
const ENEMY_PROJECTILE_LAYER = 16


@export_range(0, 2000) var speed : int = 0
@export var direction : Vector2


var ship_velocity: Vector2
var weapon : AbstractWeapon

var _velocity: Vector2


@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var out_of_screen_timer : Timer = $OutOfScreenTimer


func _ready() -> void:
	_velocity = direction.normalized() * speed + ship_velocity
	_update_collision_rotation(_velocity)


func _physics_process(delta: float) -> void:
	position += _velocity * delta


func _update_collision_rotation(velocity: Vector2) -> void:
	collision.rotation = velocity.angle() - 0.5 * PI


func _on_screen_entered() -> void:
	out_of_screen_timer.stop()


func _on_screen_exited() -> void:
	out_of_screen_timer.start()


func _on_out_of_screen_timer_timeout() -> void:
	delete()


func _try_to_damage(body: Node2D, damage: AbstractDamage) -> bool:
	var health_component : Health = body.find_child("Health")
	if health_component and health_component.has_method("apply_damage"):
		health_component.apply_damage(damage)
		return true
	return false


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	delete()


func delete() -> void:
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
	
	var groups : Array[String] = [ "enemies", "players" ]
	
	for group in groups:
		var nodes := get_tree().get_nodes_in_group(group)
		for node in nodes:
			if not node is AbstractShip: continue
			var ship := node as AbstractShip
			if collision_mask & ship.collision_layer and not node in filter:
				foes.append(node)
	
	return foes
