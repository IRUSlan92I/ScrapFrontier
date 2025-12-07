class_name EnemyGenerator
extends Node


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int) -> EnemyData:
	local_seed_rng.seed = seed_value
	
	var data : EnemyData = EnemyData.new()
	data.seed_value = seed_value
	
	
	
	return data
