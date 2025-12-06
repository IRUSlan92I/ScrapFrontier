class_name PassageGenerator
extends Node


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int) -> PassageData:
	local_seed_rng.seed = seed_value
	
	var data : PassageData = PassageData.new()
	data.seed_value = seed_value
	
	
	
	return data
