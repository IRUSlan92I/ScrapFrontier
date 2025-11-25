class_name Passage
extends Node2D


const PLAYER := preload("res://game/entities/ships/player/player_ship.tscn")


@onready var enemy_swamp_controller : EnemySwampController = $EnemySwampController
@onready var enemy_timer : Timer = $EnemyTimer


func _ready() -> void:
	_create_player()


func _create_player() -> void:
	var player : PlayerShip = PLAYER.instantiate()
	player.position = Vector2(100, 100)
	player.destroyed.connect(_create_player, CONNECT_DEFERRED)
	add_child(player)


func _on_enemy_timer_timeout() -> void:
	enemy_swamp_controller.create_enemy()
	
	enemy_timer.start(randi_range(3, 9))
