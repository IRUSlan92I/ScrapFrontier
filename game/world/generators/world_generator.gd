class_name  WorldGenerator
extends Node


const AREA_COUNT = 3


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var area_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()


@onready var area_generator : AreaGenerator = $AreaGenerator


func generate(seed_value: int) -> WorldData:
	local_seed_rng.seed = seed_value
	area_seed_rng.seed = local_seed_rng.randi()
	
	var data : WorldData = WorldData.new()
	data.seed_value = seed_value
	
	_fill_areas(data)
	
	return data


func _fill_areas(data : WorldData) -> void:
	for i in AREA_COUNT:
		var seed_value := area_seed_rng.randi()
		var area := area_generator.generate(seed_value)
		data.areas.append(area)
