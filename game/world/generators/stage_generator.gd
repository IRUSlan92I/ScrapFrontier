class_name StageGenerator
extends Node


enum StageType {
	Start,
	Inner,
	Boss,
}


const CHANSES_BY_SECTOR_COUNT : Dictionary[int, int] = {
	1: 20,
	2: 30,
	3: 50
}


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var sector_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var sector_count_rng : RandomNumberGenerator = RandomNumberGenerator.new()


@onready var sector_generator : SectorGenerator = $SectorGenerator


func generate(seed_value: int, type: StageType = StageType.Inner) -> StageData:
	local_seed_rng.seed = seed_value
	sector_seed_rng.seed = local_seed_rng.randi()
	sector_count_rng.seed = local_seed_rng.randi()
	
	var data : StageData = StageData.new()
	data.seed_value = seed_value
	
	_fill_sectors(data, type)
	
	return data


func _fill_sectors(data : StageData, type: StageType = StageType.Inner) -> void:
	var sector_count := _get_sector_count() if type == StageType.Inner else 1
	for i in sector_count:
		var seed_value := sector_seed_rng.randi()
		var sector := sector_generator.generate(seed_value)
		data.sectors.append(sector)
		match type:
			StageType.Start:
				sector.type = SectorData.SectorType.StartSector
			StageType.Boss:
				sector.type = SectorData.SectorType.BossSector


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
