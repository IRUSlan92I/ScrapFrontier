class_name AbstractProjectile
extends Area2D


const PLAYER_LAYER = 2
const ENEMY_LAYER = 4
const PLAYER_PROJECTILE_LAYER = 8
const ENEMY_PROJECTILE_LAYER = 16


@export var damage : AbstractDamage
@export_range(0, 1000) var speed : int = 0
@export_range(0, 10) var piercing: int = 0


var direction : Vector2
var ship_velocity: Vector2

var collide_player: bool:
	set(value):
		collide_player = value
		_apply_collision_mask()

var collide_enemies: bool:
	set(value):
		collide_enemies = value
		_apply_collision_mask()


var _velocity: Vector2


func _ready() -> void:
	_velocity = direction.normalized() * speed + ship_velocity
	_apply_collision_mask()


func _physics_process(delta: float) -> void:
	position += _velocity * delta


func _apply_collision_mask() -> void:
	if collide_player:
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


func _on_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	var health_component : Health = body.find_child("Health")
	if health_component and health_component.has_method("apply_damage"):
		health_component.apply_damage(damage)
		if piercing == 0:
			queue_free()
		else:
			piercing -= 1
