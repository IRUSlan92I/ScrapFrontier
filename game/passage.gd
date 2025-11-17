extends Node2D


const SMALL_ENEMY = preload("res://game/entities/ships/enemies/small/small_enemy_ship.tscn")
const MEDIUM_ENEMY = preload("res://game/entities/ships/enemies/medium/medium_enemy_ship.tscn")
const HEAVY_ENEMY = preload("res://game/entities/ships/enemies/heavy/heavy_enemy_ship.tscn")

const PLAYER := preload("res://game/entities/ships/player/player_ship.tscn")


func _ready() -> void:
	_create_player()
	_create_random_enemy()


func _create_player() -> void:
	var player : PlayerShip = PLAYER.instantiate()
	add_child(player)
	player.position = Vector2(100, 100)
	player.destroyed.connect(_create_player, CONNECT_DEFERRED)


func _create_random_enemy() -> void:
	const ENEMIES := [ SMALL_ENEMY, MEDIUM_ENEMY, HEAVY_ENEMY ]
	
	var enemy : AbstractEnemyShip = ENEMIES.pick_random().instantiate()
	add_child(enemy)
	enemy.position = Vector2(550, 180)
	enemy.destroyed.connect(_create_random_enemy, CONNECT_DEFERRED)
