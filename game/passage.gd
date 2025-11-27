class_name Passage
extends Node2D


signal player_died


const PLAYER := preload("res://game/entities/ships/player/player_ship.tscn")


@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer


func _on_enemy_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.size() < 25:
		enemy_swamp_controller.create_enemy()
	
	enemy_timer.start(randi_range(1, 3))


func _on_player_ship_destroyed() -> void:
	player_died.emit()
