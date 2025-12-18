class_name  WorldGenerator
extends Node


const AREA_COUNT = 3


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var area_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var weapon_rng : RandomNumberGenerator = RandomNumberGenerator.new()


@onready var area_generator : AreaGenerator = $AreaGenerator


func generate(seed_value: int) -> WorldData:
	local_seed_rng.seed = seed_value
	area_seed_rng.seed = local_seed_rng.randi()
	weapon_rng.seed = local_seed_rng.randi()
	
	var data : WorldData = WorldData.new()
	data.seed_value = seed_value
	
	_fill_areas(data)
	_fill_weapons(data)
	
	return data


func _fill_areas(data : WorldData) -> void:
	for i in AREA_COUNT:
		var seed_value := area_seed_rng.randi()
		var area := area_generator.generate(seed_value)
		data.areas.append(area)


func _fill_weapons(data : WorldData) -> void:
	var weapons_by_group : Dictionary[String, Array] = {}
	
	for weapon in SaveManager.WEAPONS:
		if not weapon.group in weapons_by_group:
			weapons_by_group[weapon.group] = [] as Array[WeaponData]
		weapons_by_group[weapon.group].append(weapon)
	
	for group in weapons_by_group:
		var array : Array[WeaponData] = weapons_by_group[group]
		if array.size() == 0: continue
		
		var index := weapon_rng.randi_range(1, array.size()) - 1
		data.player_start_weapons.append(array[index])
	
	data.player_start_weapons.shuffle()
