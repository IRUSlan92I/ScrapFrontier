class_name PassageGenerator
extends Node


const ENEMY_COUNT = 10
const MIN_LENGTH = 250.0
const MAX_LENGTH = 350.0


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var length_rng : RandomNumberGenerator = RandomNumberGenerator.new()


@onready var enemy_generator : EnemyGenerator = $EnemyGenerator


func generate(seed_value: int) -> PassageData:
	local_seed_rng.seed = seed_value
	enemy_seed_rng.seed = local_seed_rng.randi()
	length_rng.seed = local_seed_rng.randi()
	
	var data : PassageData = PassageData.new()
	data.seed_value = seed_value
	
	_fill_enemies(data)
	_fill_length(data)
	
	return data


func _fill_enemies(data: PassageData) -> void:
	for i in ENEMY_COUNT:
		var seed_value := enemy_seed_rng.randi()
		var enemy := enemy_generator.generate(seed_value)
		data.enemies.append(enemy)


func _fill_length(data: PassageData) -> void:
	data.length = length_rng.randf_range(MIN_LENGTH, MAX_LENGTH)
