class_name AreaMap
extends Node2D


const SECTOR_XS = [
	64 * 1, 64 * 2, 64 * 3,
	64 * 4, 64 * 5, 64 * 6,
	64 * 7, 64 * 8, 64 * 9,
]

const SECTOR_Y_OFFSET = 24

const SECTOR_YS_FOR_ONE = [
	SECTOR_Y_OFFSET + 64 * 1
]

const SECTOR_YS_FOR_TWO = [
	SECTOR_Y_OFFSET + 64 * 0.5, SECTOR_Y_OFFSET + 64 * 1.5,
]

const SECTOR_YS_FOR_THREE = [
	SECTOR_Y_OFFSET + 64 * 0, SECTOR_Y_OFFSET + 64 * 1, SECTOR_Y_OFFSET + 64 * 2,
]

const CURRENT_SECTOR_INDICATOR_OFFSET = Vector2(0, 16)

const SECTOR_SCENES : Dictionary[SectorData.SectorType, PackedScene] = {
	SectorData.SectorType.ShopSector:
		preload("res://game/area_map/indicators/sectors/shop_sector_indicator.tscn"),
	SectorData.SectorType.RepairSector:
		preload("res://game/area_map/indicators/sectors/repair_sector_indicator.tscn"),
	SectorData.SectorType.DebrisSector:
		preload("res://game/area_map/indicators/sectors/debris_sector_indicator.tscn"),
	SectorData.SectorType.StartSector:
		preload("res://game/area_map/indicators/sectors/start_sector_indicator.tscn"),
	SectorData.SectorType.BossSector:
		preload("res://game/area_map/indicators/sectors/boss_sector_indicator.tscn"),
}
const PASSAGE_SCENES : Dictionary[PassageData.PassageType, PackedScene] = {
	PassageData.PassageType.Minus45Grad:
		preload("res://game/area_map/indicators/passages/minus_45_grad_passage_indicator.tscn"),
	PassageData.PassageType.Minus26Grad:
		preload("res://game/area_map/indicators/passages/minus_26_grad_passage_indicator.tscn"),
	PassageData.PassageType.ZeroGrad:
		preload("res://game/area_map/indicators/passages/zero_grad_passage_indicator.tscn"),
	PassageData.PassageType.Plus26Grad:
		preload("res://game/area_map/indicators/passages/plus_26_grad_passage_indicator.tscn"),
	PassageData.PassageType.Plus45Grad:
		preload("res://game/area_map/indicators/passages/plus_45_grad_passage_indicator.tscn"),
}

const CURRENT_SECTOR_INDICATOR = \
	preload("res://game/area_map/indicators/current_sector_indicator.tscn")
const SELECTED_SECTOR_INDICATOR = \
	preload("res://game/area_map/indicators/selected_sector_indicator.tscn")


var area_data : AreaData = null:
	set = _set_area_data

var current_sector: SectorData = null:
	set = _set_current_sector

var selected_sector: SectorData = null:
	set = _set_selected_sector

var sector_positions : Dictionary[SectorData, Vector2] = {}

var test_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var test_seed := 0


@onready var passages_node : Node2D = $Passages
@onready var sectors_node : Node2D = $Sectors

@onready var current_sector_indicator : CurrentSectorIndicator = $CurrentSectorIndicator
@onready var selected_sector_indicator : SelectedSectorIndicator = $SelectedSectorIndicator

@onready var test_area_generator : AreaGenerator = $TestAreaGenerator


func _ready() -> void:
	area_data = test_area_generator.generate(test_seed)
	test_rng.seed = 0
	current_sector = _get_random_sector()
	selected_sector = _get_random_sector()


func _input(event: InputEvent) -> void:
	if selected_sector == null: return
	
	if event.is_action_pressed("ui_left"):
		_set_selected_sector(selected_sector.sector_to_left)
	if event.is_action_pressed("ui_right"):
		_set_selected_sector(selected_sector.sector_to_right)
	if event.is_action_pressed("ui_up"):
		_set_selected_sector(selected_sector.sector_above)
	if event.is_action_pressed("ui_down"):
		_set_selected_sector(selected_sector.sector_below)
	if event.is_action_pressed("ui_accept"):
		_load_text_test()


func _set_area_data(data: AreaData) -> void:
	area_data = data
	
	_fill_map()


func _get_random_sector() -> SectorData:
	if area_data == null: return null
	if area_data.stages.size() == 0: return null
	
	var stage_index := test_rng.randf_range(0, area_data.stages.size() - 1)
	var stage := area_data.stages[stage_index]
	
	if stage.sectors.size() == 0: return null
	var sector_index := test_rng.randf_range(0, stage.sectors.size() - 1)
	
	return stage.sectors[sector_index]


func _fill_sector_positions() -> void:
	sector_positions.clear()
	
	if area_data == null: return
	
	for stage_index in area_data.stages.size():
		var stage := area_data.stages[stage_index]
		
		for sector_index in stage.sectors.size():
			var sector := stage.sectors[sector_index]
		
			var sector_position := _get_sector_position(
				stage_index, sector_index, stage.sectors.size()
			)
			sector_positions[sector] = sector_position


func _fill_map() -> void:
	_clear_node(sectors_node)
	_clear_node(passages_node)
	_fill_sector_positions()

	if area_data == null: return
	
	for stage in area_data.stages:
		_fill_sectors(stage)


func _fill_sectors(stage: StageData) -> void:
	for sector_index in stage.sectors.size():
		var sector := stage.sectors[sector_index]
		
		if not sector in sector_positions: continue
		
		var sector_position := sector_positions[sector]
		
		_fill_passages(sector.next_passages, sector_position)
		
		if not sector.type in SECTOR_SCENES: continue
		
		var scene := SECTOR_SCENES[sector.type]
		var sector_instance : AbstractSectorIndicator = scene.instantiate()
		sector_instance.position = sector_position
		sectors_node.add_child(sector_instance)
		sector.activity_changed.connect(sector_instance.set_active)


func _fill_passages(passages: Array[PassageData], sector_position: Vector2) -> void:
	for passage in passages:
		if not passage.type in PASSAGE_SCENES: continue
		
		var scene := PASSAGE_SCENES[passage.type]
		var passage_instance : AbstractPassageIndicator = scene.instantiate()
		passage_instance.position = sector_position
		passages_node.add_child(passage_instance)
		passage.activity_changed.connect(passage_instance.set_active)


func _get_sector_position(stage_index: int, sector_index: int, sector_count: int) -> Vector2:
	var sector_position : Vector2
	
	sector_position.x = SECTOR_XS[stage_index]
	match sector_count:
		1:
			sector_position.y = SECTOR_YS_FOR_ONE[sector_index]
		2:
			sector_position.y = SECTOR_YS_FOR_TWO[sector_index]
		3:
			sector_position.y = SECTOR_YS_FOR_THREE[sector_index]
	
	return sector_position


func _clear_node(node: Node) -> void:
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()


func _set_current_sector(sector: SectorData) -> void:
	if sector == null: return
	
	if not sector in sector_positions:
		current_sector_indicator.hide()
		return
	
	current_sector = sector
	
	var sector_position := sector_positions[sector]
	current_sector_indicator.position = sector_position + CURRENT_SECTOR_INDICATOR_OFFSET
	
	_update_selected_sector_indicator()
	current_sector_indicator.show()


func _set_selected_sector(sector: SectorData) -> void:
	if sector == null: return
	
	if not sector in sector_positions:
		selected_sector_indicator.hide()
		return
	
	selected_sector = sector
	
	var sector_position := sector_positions[sector]
	selected_sector_indicator.position = sector_position
	
	_update_selected_sector_indicator()
	selected_sector_indicator.show()


func _update_selected_sector_indicator() -> void:
	if selected_sector == null: return
	
	var is_accessible := _is_sector_accessible(selected_sector)
	selected_sector_indicator.set_active(is_accessible)


func _is_sector_accessible(sector: SectorData) -> bool:
	if current_sector == null: return false
	
	for passage in current_sector.next_passages:
		if passage.next_sector == sector:
			return true
	
	return false


func _load_text_test() -> void:
	test_seed += 1
	area_data = test_area_generator.generate(test_seed)
	current_sector = _get_random_sector()
	selected_sector = _get_random_sector()
