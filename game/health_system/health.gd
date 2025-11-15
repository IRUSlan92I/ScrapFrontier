class_name Health
extends Node


signal shield_updated(value: int)
signal armor_updated(value: int)
signal hull_updated(value: int)

signal depleted


@export_range(0, 5000) var max_shield: int = 0
@export_range(0, 5000) var max_armor: int = 0
@export_range(1, 5000) var max_hull: int = 1


var shield: int:
	get: return _shield
	set(value): pass
var armor: int:
	get: return _armor
	set(value): pass
var hull: int:
	get: return _hull
	set(value): pass


@onready var _shield := max_shield
@onready var _armor := max_armor
@onready var _hull := max_hull


func apply_damage(damage: AbstractDamage) -> void:
	if _shield > 0:
		var damage_value := ceili(damage.value * damage.shield_damage_multiplier())
		_shield = max(_shield - damage_value, 0)
		shield_updated.emit(_shield)
	elif _armor > 0:
		var damage_value := ceili(damage.value * damage.armor_damage_multiplier())
		_armor = max(_armor - damage_value, 0)
		armor_updated.emit(_armor)
	else:
		if _hull == 0: return
		
		var damage_value := ceili(damage.value * damage.hull_damage_multiplier())
		_hull = max(_hull - damage_value, 0)
		hull_updated.emit(_hull)
		
		if _hull == 0:
			depleted.emit()
