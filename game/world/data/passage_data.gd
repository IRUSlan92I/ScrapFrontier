class_name PassageData
extends Resource


signal activity_changed(is_active: bool)


enum PassageType {
	Minus45Grad,
	Minus26Grad,
	ZeroGrad,
	Plus26Grad,
	Plus45Grad,
}

@export var previous_sector : SectorData
@export var next_sector : SectorData

@export var enemies : Array[EnemyData] = []

@export var seed_value : int = 0

@export var length : float = 0

@export var type : PassageType = PassageType.ZeroGrad


var is_active: bool = true:
	set(value):
		if is_active == value: return
		is_active = value
		activity_changed.emit(is_active)
