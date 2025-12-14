class_name Game
extends Node


const PASSAGE = preload("res://game/passage.tscn")
const AREA_MAP = preload("res://game/area_map/area_map.tscn")


var data : WorldData
var current_area : AreaData
var current_stage : StageData
var current_sector : SectorData
var current_passage : PassageData

var _current_passage_scene : Passage
var _current_area_map_scene : AreaMap


@onready var pause_screen : Control = $PauseScreen
@onready var game_over_screen : Control = $GameOverScreen
@onready var world_generator : WorldGenerator = $WorldGenerator


func _ready() -> void:
	pause_screen.hide()
	game_over_screen.hide()
	
	start_game(SaveManager.game_data)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.show()
		get_tree().paused = true


func start_game(game_data: GameData) -> void:
	
	if not _fill_data(game_data):
		print("Can't process game data")
		_show_main_menu()
		return
	
	if SaveManager.player_data.is_new_game:
		_initialize_new_game()
	
	_create_game_map()


func _initialize_new_game() -> void:
	for i in range(data.player_start_weapon_ids.size()):
		SaveManager.player_data.weapon_ids.append(data.player_start_weapon_ids[i])


func _fill_data(game_data: GameData) -> bool:
	data = world_generator.generate(game_data.game_seed.hash())
	
	if game_data.current_area_index >= data.areas.size(): return false
	current_area = data.areas[game_data.current_area_index]
	
	if game_data.current_stage_index >= current_area.stages.size(): return false
	current_stage = current_area.stages[game_data.current_stage_index]
	
	if game_data.current_sector_index >= current_stage.sectors.size(): return false
	current_sector = current_stage.sectors[game_data.current_sector_index]
	
	return true


func _create_game_map() -> void:
	if _current_area_map_scene != null: _current_area_map_scene.queue_free()
	
	_current_area_map_scene = AREA_MAP.instantiate()
	add_child(_current_area_map_scene)
	_current_area_map_scene.area_data = current_area
	_current_area_map_scene.current_sector = current_sector
	_current_area_map_scene.selected_sector = current_sector
	_current_area_map_scene.passage_selected.connect(_create_passage)


func _show_map() -> void:
	if _current_passage_scene != null: _current_passage_scene.queue_free()
	_current_area_map_scene.current_sector = current_sector
	_current_area_map_scene.selected_sector = current_sector
	_current_area_map_scene.show()


func _create_passage(passage_data: PassageData) -> void:
	if _current_passage_scene != null: _current_passage_scene.queue_free()
	_current_area_map_scene.hide()
	
	current_passage = passage_data
	
	_current_passage_scene = PASSAGE.instantiate()
	add_child(_current_passage_scene)
	
	_current_passage_scene.passage_data = passage_data
	_current_passage_scene.player_data = SaveManager.player_data
	_current_passage_scene.completed.connect(_on_passage_completion)
	_current_passage_scene.player_died.connect(_on_passage_player_died)


func _on_pause_screen_continue_game() -> void:
	pause_screen.hide()


func _show_main_menu() -> void:
	if _current_passage_scene: _current_passage_scene.queue_free()
	if _current_area_map_scene: _current_area_map_scene.queue_free()
	
	SaveManager.save()
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/title_screen.tscn")


func _on_passage_player_died() -> void:
	SaveManager.delete_game_data()
	game_over_screen.show()


func _on_passage_completion() -> void:
	var projectiles := get_tree().get_nodes_in_group("projectiles")
	for projectile in projectiles:
		projectile.queue_free()
	
	current_sector = current_passage.next_sector
	_update_data_indexes()
	_show_map()


func _update_data_indexes() -> void:
	for area_index in range(data.areas.size()):
		var area := data.areas[area_index]
		for stage_index in range(area.stages.size()):
			var stage := area.stages[stage_index]
			for sector_index in range(stage.sectors.size()):
				if stage.sectors[sector_index] == current_sector:
					SaveManager.game_data.current_area_index = area_index
					SaveManager.game_data.current_stage_index = stage_index
					SaveManager.game_data.current_sector_index = sector_index
					SaveManager.save()
