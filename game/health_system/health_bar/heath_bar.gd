class_name HealthBar
extends Node2D


@export var health: Health


@onready var shield_part : HealthBarPart = $ShieldPart
@onready var armor_part : HealthBarPart = $ArmorPart
@onready var hull_part : HealthBarPart = $HullPart


func _ready() -> void:
	if health:
		shield_part.set_max_value(health.max_shield)
		shield_part.set_value(health.shield)
		
		armor_part.set_max_value(health.max_armor)
		armor_part.set_value(health.armor)
		
		hull_part.set_max_value(health.max_hull)
		hull_part.set_value(health.hull)
		
		health.shield_updated.connect(shield_part.set_value)
		health.armor_updated.connect(armor_part.set_value)
		health.hull_updated.connect(hull_part.set_value)
