class_name EnemySwampController
extends Node


const SHORT_DISTANCE = 75
const MEDIUM_DISTANCE = 150
const LONG_DISTANCE = 300

const INDIRECT_OFFSET = 75

const MIN_POSITION = Vector2(300, 30)
const MAX_POSITION = Vector2(600, 330)


@export var passage : Passage


@onready var enemy_update_timer : Timer = $EnemyUpdateTimer


func create_enemy(enemy_data: EnemyData) -> void:
	var player := _get_random_player()
	if player == null: return
	
	var enemy_scene : PackedScene = load(enemy_data.enemy_scene)
	var enemy : AbstractEnemyShip = enemy_scene.instantiate()
	passage.add_child(enemy)
	enemy.position = enemy_data.spawn_point
	enemy.enemy_data = enemy_data
	enemy.velocity = enemy.position.direction_to(player.position) * enemy.max_speed
	_update_enemy.call_deferred(enemy)


func _on_enemy_update_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty(): return
	
	var enemy : Node = enemies.pick_random()
	if not enemy is AbstractEnemyShip: return
		
	_update_enemy(enemy)


func _update_enemy(enemy: AbstractEnemyShip) -> void:
	var player := _get_random_player()
	if player:
		_target_enemy_to_player(enemy, player)
	else:
		_random_move_enemy(enemy)


func _target_enemy_to_player(enemy: AbstractEnemyShip, player: PlayerShip) -> void:
	match enemy.weapon_type():
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
			_update_enemy_target_position(enemy, player, MEDIUM_DISTANCE, INDIRECT_OFFSET)


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


func _get_random_player() -> PlayerShip:
	var players := get_tree().get_nodes_in_group("players")
	if players.is_empty():
		return null
	
	var player : PlayerShip = players.pick_random()
	return player
