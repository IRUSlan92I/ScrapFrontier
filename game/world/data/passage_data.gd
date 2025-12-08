class_name PassageData
extends Resource


enum PassageAngle {
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

@export var angle : PassageAngle = PassageAngle.ZeroGrad
