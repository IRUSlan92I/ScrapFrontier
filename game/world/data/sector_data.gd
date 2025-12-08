class_name SectorData
extends Resource


signal activity_changed(is_active: bool)


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


var is_active: bool = true:
	set(value):
		if is_active == value: return
		is_active = value
		activity_changed.emit(is_active)
