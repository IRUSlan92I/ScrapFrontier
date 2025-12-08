class_name SectorGenerator
extends Node


const CHANSES_BY_SECTOR_TYPE : Dictionary[SectorData.SectorType, int] = {
	SectorData.SectorType.EmptySector: 45,
	SectorData.SectorType.ShopSector: 30,
	SectorData.SectorType.RepairSector: 20,
	SectorData.SectorType.DebrisSector: 5,
}


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var sector_type_rng : RandomNumberGenerator = RandomNumberGenerator.new()


func generate(seed_value: int) -> SectorData:
	local_seed_rng.seed = seed_value
	sector_type_rng.seed = local_seed_rng.randi()
	
	var data : SectorData = SectorData.new()
	data.seed_value = seed_value
	
	data.type = _get_sector_type()
	
	return data


func _get_sector_type() -> SectorData.SectorType:
	var total_chance := 0
	for type in CHANSES_BY_SECTOR_TYPE:
		total_chance += CHANSES_BY_SECTOR_TYPE[type]
	
	var threshold := sector_type_rng.randi_range(1, total_chance)
	
	var cumulative := 0
	for type in CHANSES_BY_SECTOR_TYPE:
		cumulative += CHANSES_BY_SECTOR_TYPE[type]
		if threshold <= cumulative:
			return type
	
	return SectorData.SectorType.EmptySector
