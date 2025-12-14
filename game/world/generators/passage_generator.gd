class_name PassageGenerator
extends Node


const ENEMY_COUNT_MEAN = 50.0
const ENEMY_COUNT_DEVIATION = 100.0

const LENGTH_MEAN = 300.0
const LENGTH_DEVIATION = 50.0

const SPAWN_START_DELAY = 3
const SPAWN_END_DELAY = 3

const USE_NEXT_WEAPON_CHANCE = 10


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var weapon_ids_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var length_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_count_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_spawn_time_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_weapon_rng : RandomNumberGenerator = RandomNumberGenerator.new()

var weapon_ids : Array[String]


@onready var enemy_generator : EnemyGenerator = $EnemyGenerator


func generate(seed_value: int) -> PassageData:
	local_seed_rng.seed = seed_value
	weapon_ids_rng.seed = local_seed_rng.randi()
	length_rng.seed = local_seed_rng.randi()
	enemy_seed_rng.seed = local_seed_rng.randi()
	enemy_count_rng.seed = local_seed_rng.randi()
	enemy_spawn_time_rng.seed = local_seed_rng.randi()
	enemy_weapon_rng.seed = local_seed_rng.randi()
	
	weapon_ids = _get_weapon_ids()
	
	var data : PassageData = PassageData.new()
	data.seed_value = seed_value
	
	_fill_length(data)
	_fill_enemies(data)
	
	return data


func _get_weapon_ids() -> Array[String]:
	var array : Array[String] = AbstractShip.WEAPON_SCENES.keys().duplicate()
	
	for i in range(array.size() - 1, 0, -1):
		var j := weapon_ids_rng.randi_range(0, i)
		
		var temp := array[i]
		array[i] = array[j]
		array[j] = temp
	
	return array


func _fill_length(data: PassageData) -> void:
	data.length = length_rng.randfn(LENGTH_MEAN, LENGTH_DEVIATION)


func _fill_enemies(data: PassageData) -> void:
	var spawn_end_time := floori(data.length - SPAWN_END_DELAY)
	
	var enemy_count := roundi(enemy_count_rng.randfn(ENEMY_COUNT_MEAN, ENEMY_COUNT_DEVIATION))
	for i in range(enemy_count):
		var seed_value := enemy_seed_rng.randi()
		var enemy := enemy_generator.generate(seed_value)
		
		enemy.spawn_time = enemy_spawn_time_rng.randi_range(SPAWN_START_DELAY, spawn_end_time)
		enemy.weapon_id = _get_weapon_id()
		
		data.enemies.append(enemy)
	
	var enemy_spawn_time_compare := func(a: EnemyData, b: EnemyData) -> bool:
		return a.spawn_time > b.spawn_time
	data.enemies.sort_custom(enemy_spawn_time_compare)


func _get_weapon_id() -> String:
	var index := 0
	
	while [index < weapon_ids.size()]:
		if enemy_weapon_rng.randi_range(1, 100) <= USE_NEXT_WEAPON_CHANCE:
			index += 1
		else:
			break
	
	return weapon_ids[index]
