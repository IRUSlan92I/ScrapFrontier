class_name Passage
extends Node2D


signal player_died


@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer


func _on_enemy_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.size() < 25:
		enemy_swamp_controller.create_enemy()
	
	var factor := maxi(enemies.size(), 1) * 0.5
	
	enemy_timer.start(randf_range(1 * factor, 2 * factor))


func _on_player_ship_destroyed() -> void:
	player_died.emit()
