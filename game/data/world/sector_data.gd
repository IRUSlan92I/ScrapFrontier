class_name SectorData
extends Resource


signal activity_changed(is_active: bool)


enum SectorType {
	ShopSector,
	RepairSector,
	DebrisSector,
	StartSector,
	BossSector,
}


@export var previous_passages : Array[PassageData] = []
@export var next_passages : Array[PassageData] = []

@export var seed_value : int = 0

@export var type : SectorType = SectorType.DebrisSector

@export var sector_to_left: SectorData = null
@export var sector_to_right: SectorData = null
@export var sector_above: SectorData = null
@export var sector_below: SectorData = null


var is_active: bool = true:
	set(value):
		if is_active == value: return
		is_active = value
		activity_changed.emit(is_active)
