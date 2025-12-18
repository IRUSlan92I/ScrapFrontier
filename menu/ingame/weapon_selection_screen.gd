class_name WeaponSelectionScreen
extends Control


signal weapon_selected(weapon_data: WeaponData)


const WEAPON_SELECTOR = preload("res://menu/ingame/weapon_selector.tscn")


@export var world_data : WorldData:
	set = _set_world_data


@onready var weapon_selectors : Control = $%WeaponSelectors


func _set_world_data(data: WorldData) -> void:
	world_data = data
	
	for child in weapon_selectors.get_children():
		child.queue_free()
	
	if world_data == null: return
	
	var selectors : Array[WeaponSelector] = []
	for weapon_data in world_data.player_start_weapons:
		var selector : WeaponSelector = WEAPON_SELECTOR.instantiate()
		weapon_selectors.add_child(selector)
		selector.weapon_data = weapon_data
		selectors.append(selector)
		selector.weapon_selected.connect(_on_weapon_selected)
	
	if selectors.size() > 0:
		selectors[0].button.grab_focus()


func _on_weapon_selected(weapon_data: WeaponData) -> void:
	weapon_selected.emit(weapon_data)
