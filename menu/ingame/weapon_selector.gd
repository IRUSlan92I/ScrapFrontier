class_name WeaponSelector
extends Control


signal weapon_selected(weapon_data: WeaponData)


@export var weapon_data: WeaponData:
	set = _set_weapon_data


@onready var name_label : Label = $%NameLabel
@onready var button : Button = $%Button


func _set_weapon_data(data: WeaponData) -> void:
	weapon_data = data
	
	if weapon_data == null: return
	
	name_label.text = weapon_data.name


func _on_button_pressed() -> void:
	weapon_selected.emit(weapon_data)
