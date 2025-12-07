class_name Health
extends Node


signal shield_updated(value: int, max_value: int)
signal armor_updated(value: int, max_value: int)
signal hull_updated(value: int, max_value: int)

signal depleted


@export_range(0, 5000) var max_shield: int = 0:
	set(value):
		max_shield = value
		shield_updated.emit(_shield, max_shield)

@export_range(0, 5000) var max_armor: int = 0:
	set(value):
		max_armor = value
		armor_updated.emit(_armor, max_armor)

@export_range(1, 5000) var max_hull: int = 1:
	set(value):
		max_hull = value
		hull_updated.emit(_hull, max_hull)


var shield: int:
	get: return _shield
	set(value): pass
var armor: int:
	get: return _armor
	set(value): pass
var hull: int:
	get: return _hull
	set(value): pass


@onready var shield_regen_delay_timer : Timer = $ShieldRegenDelayTimer
@onready var shield_regen_tick_timer : Timer = $ShieldRegenTickTimer


@onready var _shield := max_shield:
	set(value):
		_shield = value
		shield_updated.emit(_shield, max_shield)
@onready var _armor := max_armor:
	set(value):
		_armor = value
		armor_updated.emit(_armor, max_armor)
@onready var _hull := max_hull:
	set(value):
		_hull = value
		hull_updated.emit(_hull, max_hull)

@onready var _shield_regen := floori(max_shield/30.0)


func apply_damage(damage: AbstractDamage) -> void:
	if _shield > 0:
		var damage_value := ceili(damage.value * damage.shield_damage_multiplier())
		_shield = max(_shield - damage_value, 0)
		shield_regen_delay_timer.start()
	elif _armor > 0:
		var damage_value := ceili(damage.value * damage.armor_damage_multiplier())
		_armor = max(_armor - damage_value, 0)
	else:
		if _hull == 0: return
		
		var damage_value := ceili(damage.value * damage.hull_damage_multiplier())
		_hull = max(_hull - damage_value, 0)
		
		if _hull == 0:
			depleted.emit()
			
	if not shield_regen_delay_timer.is_stopped():
		shield_regen_delay_timer.start()
	shield_regen_tick_timer.stop()


func _on_shield_regen_delay_timer_timeout() -> void:
	shield_regen_tick_timer.start()


func _on_shield_regen_tick_timer_timeout() -> void:
	var new_shield_value := _shield + _shield_regen
	if new_shield_value >= max_shield:
		new_shield_value = max_shield
		shield_regen_tick_timer.stop()
	_shield = new_shield_value
