class_name EnemySwampController
extends Node


@export var passage : Passage


const SMALL_ENEMY = preload("res://game/entities/ships/enemies/small/small_enemy_ship.tscn")
const MEDIUM_ENEMY = preload("res://game/entities/ships/enemies/medium/medium_enemy_ship.tscn")
const HEAVY_ENEMY = preload("res://game/entities/ships/enemies/heavy/heavy_enemy_ship.tscn")

const ENEMY_TYPES := [ SMALL_ENEMY, MEDIUM_ENEMY, HEAVY_ENEMY ]


@onready var enemy_update_timer : Timer = $EnemyUpdateTimer


func create_enemy() -> void:
	var enemy : AbstractEnemyShip = ENEMY_TYPES.pick_random().instantiate()
	enemy.position = Vector2(750, randi_range(0, 360))
	passage.add_child(enemy)
	
	_update_enemy.call_deferred(enemy)


func _on_enemy_update_timer_timeout() -> void:
	enemy_update_timer.start(randi_range(3, 9))
	
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty(): return
	
	var enemy : Node = enemies.pick_random()
	if not enemy is AbstractEnemyShip: return
		
	_update_enemy(enemy)


func _update_enemy(enemy: AbstractEnemyShip) -> void:
	enemy.controller.target_position = Vector2(randi_range(300, 600), randi_range(30, 330))
