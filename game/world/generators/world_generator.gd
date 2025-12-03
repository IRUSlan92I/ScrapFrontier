extends Node


func generate(seed_string: String) -> WorldData:
	var data : WorldData = WorldData.new()
	
	data.seed_string = seed_string
	
	_fill_areas(data)
	
	return data


func _fill_areas(data : WorldData) -> void:
	const MAX_AREA_COUNT = 3
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(data.seed_string)
	
	for i in MAX_AREA_COUNT:
		pass
