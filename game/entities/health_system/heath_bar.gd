class_name HealthBar
extends Control


@export var health: Health


@onready var hull_part : HealthBarPart = $HullPart


func _ready() -> void:
	if not health: return
	
	hull_part.set_max_value(health.max_hull)
	hull_part.set_value(health.hull)
	
	health.hull_updated.connect(_on_hull_updated)


func _on_hull_updated(value: int, max_value: int) -> void:
	hull_part.set_value(value)
	hull_part.set_max_value(max_value)
