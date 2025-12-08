class_name SectorData
extends Resource


enum SectorType {
	EmptySector,
	ShopSector,
	RepairSector,
	DebrisSector,
	StartSector,
	BossSector,
}


@export var previous_passages : Array[PassageData] = []
@export var next_passages : Array[PassageData] = []

@export var seed_value : int = 0

@export var type : SectorType = SectorType.EmptySector
