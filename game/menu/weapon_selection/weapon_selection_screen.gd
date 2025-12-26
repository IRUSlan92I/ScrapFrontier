class_name WeaponSelectionScreen
extends Control


signal weapon_selected(weapon_data: WeaponData)


const WEAPON_SELECTOR = preload("res://game/menu/weapon_selection/weapon_selector.tscn")


@export var world_data : WorldData:
	set = _set_world_data


@onready var weapon_selectors : Control = $%WeaponSelectors


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") and _play_left_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_previous)
	if event.is_action_pressed("ui_right") and _play_right_sound():
		SoundManager.play_ui_stream(SoundManager.ui_stream_next)


func _play_left_sound() -> bool:
	return _play_side_sound(1, 0)


func _play_right_sound() -> bool:
	return _play_side_sound(0, 1)


func _play_side_sound(offset_begin: int, offset_end: int) -> bool:
	for i in range(offset_begin, weapon_selectors.get_child_count() - offset_end):
		var child := weapon_selectors.get_child(i)
		if child is WeaponSelector and child.button.has_focus():
			return true
	return false


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
