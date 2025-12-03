class_name AreaGenerator
extends Node


func generate(seed_value: int) -> AreaData:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	
	var data : AreaData = AreaData.new()
	data.seed_value = seed_value
	
	_fill_stages(rng, data)
	
	return data


func _fill_stages(rng: RandomNumberGenerator, data : AreaData) -> void:
	pass
