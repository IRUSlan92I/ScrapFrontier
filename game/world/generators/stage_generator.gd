class_name StageGenerator
extends Node


const CHANSES_BY_SECTOR_COUNT : Dictionary[int, int] = {
	1: 25,
	2: 60,
	3: 15
}


@onready var sector_generator : SectorGenerator = $SectorGenerator


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var sector_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var sector_count_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int, is_endpoint: bool = false) -> StageData:
	local_seed_rng.seed = seed_value
	sector_seed_rng.seed = local_seed_rng.randi()
	sector_count_rng.seed = local_seed_rng.randi()
	
	var data : StageData = StageData.new()
	data.seed_value = seed_value
	
	_fill_sectors(data, is_endpoint)
	
	return data


func _fill_sectors(data : StageData, is_endpoint: bool = false) -> void:
	var sector_count := 1 if is_endpoint else _get_sector_count()
	for i in sector_count:
		var seed_value := sector_seed_rng.randi()
		var sector := sector_generator.generate(seed_value)
		data.sectors.append(sector)


func _get_sector_count() -> int:
	var total_chance := 0
	for count in CHANSES_BY_SECTOR_COUNT:
		total_chance += CHANSES_BY_SECTOR_COUNT[count]
	
	var threshold := sector_count_rng.randi_range(1, total_chance)
	
	var cumulative := 0
	for count in CHANSES_BY_SECTOR_COUNT:
		cumulative += CHANSES_BY_SECTOR_COUNT[count]
		if threshold <= cumulative:
			return count
	
	return 1
