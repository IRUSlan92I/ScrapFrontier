class_name EnemySwampController
extends Node


@export var passage : Passage


const SMALL_ENEMY = preload("res://game/entities/ships/enemies/small/small_enemy_ship.tscn")
const MEDIUM_ENEMY = preload("res://game/entities/ships/enemies/medium/medium_enemy_ship.tscn")
const HEAVY_ENEMY = preload("res://game/entities/ships/enemies/heavy/heavy_enemy_ship.tscn")

const ENEMY_TYPES := [ SMALL_ENEMY, MEDIUM_ENEMY, HEAVY_ENEMY ]

const SHORT_DISTANCE = 75
const MEDIUM_DISTANCE = 150
const LONG_DISTANCE = 300

const INDIRECT_OFFSET = 75

const MIN_POSITION = Vector2(300, 30)
const MAX_POSITION = Vector2(600, 330)


@onready var enemy_update_timer : Timer = $EnemyUpdateTimer


func create_enemy() -> void:
	var enemy : AbstractEnemyShip = ENEMY_TYPES.pick_random().instantiate()
	enemy.position = Vector2(750, randi_range(0, 360))
	passage.add_child(enemy)
	
	_update_enemy.call_deferred(enemy)


func _on_enemy_update_timer_timeout() -> void:	
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty(): return
	
	var enemy : Node = enemies.pick_random()
	if not enemy is AbstractEnemyShip: return
		
	_update_enemy(enemy)


func _update_enemy(enemy: AbstractEnemyShip) -> void:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		_random_move_enemy(enemy)
		return
	
	var player : Node = players.pick_random()
	if not player is PlayerShip:
		_random_move_enemy(enemy)
		return
	
	_target_enemy_to_player(enemy, player)


func _target_enemy_to_player(enemy: AbstractEnemyShip, player: PlayerShip) -> void:
	match enemy.weapon_type:
		AbstractWeapon.Type.NONE:
			_random_move_enemy(enemy)
		AbstractWeapon.Type.SHORT_RANGE:
			_update_enemy_target_position(enemy, player, SHORT_DISTANCE)
		AbstractWeapon.Type.MEDIUM_RANGE:
			_update_enemy_target_position(enemy, player, MEDIUM_DISTANCE)
		AbstractWeapon.Type.LONG_RANGE:
			_update_enemy_target_position(enemy, player, LONG_DISTANCE)
		AbstractWeapon.Type.HOMING:
			_update_enemy_target_position(enemy, player, LONG_DISTANCE, INDIRECT_OFFSET)
		AbstractWeapon.Type.MINES:
			_update_enemy_target_position(enemy, player, SHORT_DISTANCE, INDIRECT_OFFSET)


func _update_enemy_target_position(
	enemy: AbstractEnemyShip,
	player: PlayerShip,
	distance: int,
	offset: int = 0
) -> void:
	var new_position := player.position
	new_position.x += distance
	
	if offset != 0:
		if randi_range(0, 1) == 0:
			new_position.y += offset
		else:
			new_position.y -= offset
	
	enemy.controller.target_position = new_position.clamp(MIN_POSITION, MAX_POSITION)


func _random_move_enemy(enemy: AbstractEnemyShip) -> void:
	enemy.controller.target_position = Vector2(
		randf_range(MIN_POSITION.x, MAX_POSITION.x),
		randf_range(MIN_POSITION.y, MAX_POSITION.y)
	)
