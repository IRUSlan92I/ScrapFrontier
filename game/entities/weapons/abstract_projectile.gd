class_name AbstractProjectile
extends CharacterBody2D


const PLAYER_LAYER = 2
const ENEMY_LAYER = 4
const PLAYER_PROJECTILE_LAYER = 8
const ENEMY_PROJECTILE_LAYER = 16
const PROJECTILE_BORDER_LAYER = 32


signal destroyed


@export var damage : int
@export var speed : int
@export var direction : Vector2
@export var acceleration : int
@export var max_distance : int
@export var max_livetime : int
@export var piercing: int

@export var collide_player: bool:
	set(value):
		collide_player = value
		_apply_collision_mask()
	get:
		return collide_player

@export var collide_enemies: bool:
	set(value):
		collide_enemies = value
		_apply_collision_mask()
	get:
		return collide_enemies


var _traveled_distance: float
var _livetime: float


func _ready() -> void:
	velocity = direction.normalized() * speed
	_apply_collision_mask()


func _physics_process(_delta: float) -> void:
	var was_collided := move_and_slide()
	if was_collided:
		destroyed.emit()
		queue_free()


func process_acceleration(delta: float) -> void:
	var current_acceleration := acceleration * delta
	if current_acceleration > 0:
		velocity += velocity.normalized() * current_acceleration
	elif current_acceleration < 0:
		if velocity.length() > current_acceleration:
			velocity += velocity.normalized() * current_acceleration
		else:
			velocity = Vector2.ZERO


func process_distance(delta: float) -> void:
	_traveled_distance += velocity.length() * delta
	if max_distance > 0 and _traveled_distance > max_distance:
		destroyed.emit()
		queue_free()


func process_livetime(delta: float) -> void:
	_livetime += delta
	if _livetime > max_livetime:
		destroyed.emit()
		queue_free()

func _apply_collision_mask() -> void:
	collision_mask |= PROJECTILE_BORDER_LAYER
	
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
	
