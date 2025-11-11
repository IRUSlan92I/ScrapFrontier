class_name Health
extends Node


signal depleted


@export_range(0, 5000) var max_shield: int = 0
@export_range(0, 5000) var max_armor: int = 0
@export_range(1, 5000) var max_hull: int = 1


@onready var _shield := max_shield
@onready var _armor := max_armor
@onready var _hull := max_hull


func apply_damage(damage: AbstractDamage) -> void:
	if _shield > 0:
		var damage_value := ceili(damage.value * damage.shield_damage_multiplier())
		_shield = max(_shield - damage_value, 0)
	elif _armor > 0:
		var damage_value := ceili(damage.value * damage.armor_damage_multiplier())
		_armor = max(_armor - damage_value, 0)
	else:
		if _hull == 0: return
		
		var damage_value := ceili(damage.value * damage.hull_damage_multiplier())
		_hull = max(_hull - damage_value, 0)
		
		if _hull == 0:
			depleted.emit()
