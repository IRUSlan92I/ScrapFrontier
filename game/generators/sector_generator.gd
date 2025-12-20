class_name SectorGenerator
extends Node

const SECTOR_TYPES : Array[SectorData.SectorType] = [
	SectorData.SectorType.ShopSector,
	SectorData.SectorType.RepairSector,
	SectorData.SectorType.DebrisSector,
]
const SECTOR_CHANCES : Array[int] = [
	40,
	20,
	40,
]


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
	var index := sector_type_rng.rand_weighted(SECTOR_CHANCES)
	return SECTOR_TYPES[index]
