class_name StageGenerator
extends Node


enum StageType {
	Start,
	Inner,
	Boss,
}


const SECTOR_COUNTS : Array[int] = [
	1,
	2,
	3,
]
const SECTOR_CHANCES : Array[int] = [
	20,
	30,
	50,
]


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
	_update_neighbors(data)


func _get_sector_count() -> int:
	var index := sector_count_rng.rand_weighted(SECTOR_CHANCES)
	return SECTOR_COUNTS[index]


func _update_neighbors(data : StageData) -> void:
	var size := data.sectors.size()
	for i in range(size):
		if i > 0:
			data.sectors[i].sector_above = data.sectors[i-1]
		if i < size - 1:
			data.sectors[i].sector_below = data.sectors[i+1]
