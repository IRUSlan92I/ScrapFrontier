class_name HealthBar
extends Control


@export var health: Health


@onready var small_shield_part : HealthBarPart = $SmallShieldPart
@onready var large_shield_part : HealthBarPart = $LargeShieldPart
@onready var armor_part : HealthBarPart = $ArmorPart
@onready var hull_part : HealthBarPart = $HullPart


func _ready() -> void:
	if not health: return
	
	small_shield_part.set_max_value(health.max_shield)
	small_shield_part.set_value(health.shield)
	
	large_shield_part.set_max_value(health.max_shield)
	large_shield_part.set_value(health.shield)
	
	armor_part.set_max_value(health.max_armor)
	armor_part.set_value(health.armor)
	
	hull_part.set_max_value(health.max_hull)
	hull_part.set_value(health.hull)
	
	_select_armor_part(health.armor)
	
	health.shield_updated.connect(_on_shield_updated)
	health.armor_updated.connect(_on_armor_updated)
	health.hull_updated.connect(_on_hull_updated)


func _on_shield_updated(value: int, max_value: int) -> void:
	small_shield_part.set_value(value)
	large_shield_part.set_value(value)
	small_shield_part.set_max_value(max_value)
	large_shield_part.set_max_value(max_value)


func _on_armor_updated(value: int, max_value: int) -> void:
	armor_part.set_value(value)
	armor_part.set_max_value(max_value)
	_select_armor_part(value)


func _on_hull_updated(value: int, max_value: int) -> void:
	hull_part.set_value(value)
	hull_part.set_max_value(max_value)


func _select_armor_part(armor_value: int) -> void:
	if armor_value == 0:
		armor_part.hide()
		small_shield_part.show()
		large_shield_part.hide()
	else:
		armor_part.show()
		small_shield_part.hide()
		large_shield_part.show()
