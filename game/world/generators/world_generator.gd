class_name  WorldGenerator
extends Node


@onready var area_generator : AreaGenerator = $AreaGenerator


const MAX_AREA_COUNT = 3


func generate(seed_value: int) -> WorldData:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	
	var data : WorldData = WorldData.new()
	data.seed_value = seed_value
	
	_fill_areas(rng, data)
	
	return data


func _fill_areas(rng: RandomNumberGenerator, data : WorldData) -> void:
	for i in MAX_AREA_COUNT:
		var seed_value := rng.randi()
		var area := area_generator.generate(seed_value)
		data.areas.append(area)
