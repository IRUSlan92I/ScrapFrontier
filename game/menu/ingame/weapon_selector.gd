class_name WeaponSelector
extends Control


signal weapon_selected(weapon_data: WeaponData)


@export var weapon_data: WeaponData:
	set = _set_weapon_data


@onready var button : Button = $%Button
@onready var name_label : Label = $%NameLabel
@onready var description_label : Label = $%DescriptionLabel


func _set_weapon_data(data: WeaponData) -> void:
	weapon_data = data
	
	if weapon_data == null: return
	
	name_label.text = weapon_data.name
	description_label.text = weapon_data.description


func _on_button_pressed() -> void:
	SoundManager.play_ui_stream(SoundManager.ui_stream_accept)
	weapon_selected.emit(weapon_data)
