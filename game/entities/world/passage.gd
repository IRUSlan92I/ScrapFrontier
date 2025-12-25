class_name Passage
extends Node2D


signal player_died
signal completed


@export var passage_data : PassageData:
	set = _set_passage_data

@export var player_data : PlayerData:
	set = _set_player_data


var _current_progress := 0.0
var _timer_time_elapsed := 0.0
var _current_enemy_index := 0
var _player_is_alive := true


@onready var player : PlayerShip = $PlayerShip
@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer
@onready var progress_bar : TextureProgressBar = $ProgressBar


func _physics_process(delta: float) -> void:
	if _player_is_alive:
		_current_progress += delta
		_update_progress_indicator()
		if _current_progress >= passage_data.length:
			completed.emit()


func _set_passage_data(new_data: PassageData) -> void:
	passage_data = new_data
	if passage_data and progress_bar:
		_update_progress_indicator()
	_current_enemy_index = 0
	_timer_time_elapsed = 0
	
	_start_timer_for_current_enemy()


func _set_player_data(new_data: PlayerData) -> void:
	player_data = new_data
	if passage_data and player:
		player.player_data = player_data


func _update_progress_indicator() -> void:
	progress_bar.value = _current_progress
	progress_bar.max_value = passage_data.length


func _start_timer_for_current_enemy() -> void:
	if passage_data == null: return
	if _current_enemy_index >= passage_data.enemies.size(): return
	
	var enemy := passage_data.enemies[_current_enemy_index]
	var time := enemy.spawn_time - _timer_time_elapsed
	enemy_timer.start(time)
	_timer_time_elapsed += time


func _on_enemy_timer_timeout() -> void:
	if not _player_is_alive: return
	var enemy := passage_data.enemies[_current_enemy_index]
	enemy_swamp_controller.create_enemy(enemy)
	_current_enemy_index += 1
	_start_timer_for_current_enemy()


func _on_player_ship_destroyed() -> void:
	_player_is_alive = false
	player_died.emit()
