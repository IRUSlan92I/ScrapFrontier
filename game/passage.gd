class_name Passage
extends Node2D


signal player_died


@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer
@onready var paralax_1 : Parallax2D = $Background/Parallax1
@onready var paralax_2 : Parallax2D = $Background/Parallax2
@onready var paralax_3 : Parallax2D = $Background/Parallax3


func _ready() -> void:
	paralax_1.scroll_offset.x = randf_range(1, paralax_1.repeat_size.x)
	paralax_2.scroll_offset.x = randf_range(1, paralax_2.repeat_size.x)
	paralax_3.scroll_offset.x = randf_range(1, paralax_3.repeat_size.x)


func _on_enemy_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.size() < 1:
		enemy_swamp_controller.create_enemy()
	
	var factor := maxi(enemies.size(), 1) * 0.5
	
	enemy_timer.start(randf_range(1 * factor, 3 * factor))


func _on_player_ship_destroyed() -> void:
	player_died.emit()
