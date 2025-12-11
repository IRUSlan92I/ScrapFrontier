class_name Passage
extends Node2D


signal player_died


@export var data : PassageData:
	set = _set_data


var _current_progress := 0.0


@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer
@onready var progress_bar : TextureProgressBar = $ProgressBar


func _physics_process(delta: float) -> void:
	if data:
		_current_progress += delta
		_update_progress_indicator()


func _set_data(new_data: PassageData) -> void:
	data = new_data
	if data and progress_bar:
		_update_progress_indicator()


func _update_progress_indicator() -> void:
	progress_bar.value = _current_progress
	progress_bar.max_value = data.length


func _on_enemy_timer_timeout() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.size() < 25:
		enemy_swamp_controller.create_enemy()
	
	var factor := maxi(enemies.size(), 1) * 0.5
	
	enemy_timer.start(randf_range(1 * factor, 2 * factor))


func _on_player_ship_destroyed() -> void:
	player_died.emit()
