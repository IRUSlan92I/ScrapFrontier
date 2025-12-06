class_name SectorGenerator
extends Node


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int) -> SectorData:
	local_seed_rng.seed = seed_value
	
	var data : SectorData = SectorData.new()
	data.seed_value = seed_value
	
	
	
	return data
