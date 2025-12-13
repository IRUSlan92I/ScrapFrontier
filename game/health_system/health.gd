class_name Health
extends Node


signal shield_updated(value: int, max_value: int)
signal armor_updated(value: int, max_value: int)
signal hull_updated(value: int, max_value: int)

signal depleted


@export_range(0, 5000) var max_shield: int = 0:
	set(value):
		max_shield = value
		shield_updated.emit(shield, max_shield)

@export_range(0, 5000) var max_armor: int = 0:
	set(value):
		max_armor = value
		armor_updated.emit(armor, max_armor)

@export_range(1, 5000) var max_hull: int = 1:
	set(value):
		max_hull = value
		hull_updated.emit(hull, max_hull)


var shield: int:
	set(value):
		shield = value
		shield_updated.emit(shield, max_shield)
var armor: int:
	set(value):
		armor = value
		armor_updated.emit(armor, max_armor)
var hull: int:
	set(value):
		hull = value
		hull_updated.emit(hull, max_hull)


@onready var shield_regen_delay_timer : Timer = $ShieldRegenDelayTimer
@onready var shield_regen_tick_timer : Timer = $ShieldRegenTickTimer


@onready var _shield_regen := floori(max_shield/30.0)


func _ready() -> void:
	shield = max_shield
	armor = max_armor
	hull = max_hull


func apply_damage(damage: AbstractDamage) -> void:
	if shield > 0:
		var damage_value := ceili(damage.value * damage.shield_damage_multiplier())
		shield = max(shield - damage_value, 0)
		shield_regen_delay_timer.start()
	elif armor > 0:
		var damage_value := ceili(damage.value * damage.armor_damage_multiplier())
		armor = max(armor - damage_value, 0)
	else:
		if hull == 0: return
		
		var damage_value := ceili(damage.value * damage.hull_damage_multiplier())
		hull = max(hull - damage_value, 0)
		
		if hull == 0:
			depleted.emit()
			
	if not shield_regen_delay_timer.is_stopped():
		shield_regen_delay_timer.start()
	shield_regen_tick_timer.stop()


func _on_shield_regen_delay_timer_timeout() -> void:
	shield_regen_tick_timer.start()


func _on_shield_regen_tick_timer_timeout() -> void:
	var new_shield_value := shield + _shield_regen
	if new_shield_value >= max_shield:
		new_shield_value = max_shield
		shield_regen_tick_timer.stop()
	shield = new_shield_value
