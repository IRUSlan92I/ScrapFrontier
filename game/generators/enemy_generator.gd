class_name EnemyGenerator
extends Node


enum EnemyType {
	Small,
	Medium,
	Heavy,
}


const ENEMY_TYPES : Array[EnemyType] = [
	EnemyType.Small,
	EnemyType.Medium,
	EnemyType.Heavy,
]
const ENEMY_CHANCES : Array[int] = [
	45,
	35,
	20,
]

const ENEMY_SCENES : Dictionary[EnemyType, String] = {
	EnemyType.Small: "res://game/entities/ships/enemies/small/small_enemy_ship.tscn",
	EnemyType.Medium: "res://game/entities/ships/enemies/medium/medium_enemy_ship.tscn",
	EnemyType.Heavy: "res://game/entities/ships/enemies/heavy/heavy_enemy_ship.tscn",
}

const ENEMY_MAX_WEAPON_COUNT : Dictionary[EnemyType, int] = {
	EnemyType.Small: 1,
	EnemyType.Medium: 2,
	EnemyType.Heavy: 3,
}


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var spawn_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var type_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var weapon_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int) -> EnemyData:
	local_seed_rng.seed = seed_value
	spawn_rng.seed = local_seed_rng.randi()
	type_rng.seed = local_seed_rng.randi()
	weapon_rng.seed = local_seed_rng.randi()
	
	var type := _get_enemy_type()
	
	var data : EnemyData = EnemyData.new()
	data.seed_value = seed_value
	
	_full_spawn(data)
	_full_scene(data, type)
	_full_weapon(data, type)
	
	return data


func _get_enemy_type() -> EnemyType:
	var index := type_rng.rand_weighted(ENEMY_CHANCES)
	return ENEMY_TYPES[index]


func _full_spawn(data: EnemyData) -> void:
	data.spawn_point.x = 710
	data.spawn_point.y = spawn_rng.randf_range(0.0, 360.0)


func _full_scene(data: EnemyData, type: EnemyType) -> void:
	data.enemy_scene = ENEMY_SCENES[type]


func _full_weapon(data: EnemyData, type: EnemyType) -> void:
	data.weapon_count = randi_range(1, ENEMY_MAX_WEAPON_COUNT[type])
