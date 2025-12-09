class_name AreaGenerator
extends Node


const STAGE_COUNT = 9

const EXTRA_PASSAGE_CHANCE = 33

const PASSAGE_TYPES = {
	"1 1 0": PassageData.PassageType.ZeroGrad,
	"1 2 0": PassageData.PassageType.Minus26Grad,
	"1 2 -1": PassageData.PassageType.Plus26Grad,
	"1 3 0": PassageData.PassageType.Plus45Grad,
	"1 3 -1": PassageData.PassageType.ZeroGrad,
	"1 3 -2": PassageData.PassageType.Minus45Grad,
	
	"2 1 1": PassageData.PassageType.Minus26Grad,
	"2 1 0": PassageData.PassageType.Plus26Grad,
	"2 2 1": PassageData.PassageType.Minus45Grad,
	"2 2 0": PassageData.PassageType.ZeroGrad,
	"2 2 -1": PassageData.PassageType.Plus45Grad,
	"2 3 0": PassageData.PassageType.Minus26Grad,
	"2 3 -1": PassageData.PassageType.Plus26Grad,
	
	"3 1 2": PassageData.PassageType.Minus45Grad,
	"3 1 1": PassageData.PassageType.ZeroGrad,
	"3 1 0": PassageData.PassageType.Plus45Grad,
	"3 2 1": PassageData.PassageType.Minus26Grad,
	"3 2 0": PassageData.PassageType.Plus26Grad,
	"3 3 1": PassageData.PassageType.Minus45Grad,
	"3 3 0": PassageData.PassageType.ZeroGrad,
	"3 3 -1": PassageData.PassageType.Plus45Grad,
}


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var stage_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_chance_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_direction_rng : RandomNumberGenerator = RandomNumberGenerator.new()


@onready var stage_generator : StageGenerator = $StageGenerator
@onready var passage_generator : PassageGenerator = $PassageGenerator


func generate(seed_value: int) -> AreaData:
	local_seed_rng.seed = seed_value
	stage_seed_rng.seed = local_seed_rng.randi()
	passage_seed_rng.seed = local_seed_rng.randi()
	passage_chance_rng.seed = local_seed_rng.randi()
	passage_direction_rng.seed = local_seed_rng.randi()
	
	var data : AreaData = AreaData.new()
	data.seed_value = seed_value
	
	_fill_stages(data)
	_fill_passages(data)
	
	return data


func _fill_stages(data : AreaData) -> void:
	for i in range(STAGE_COUNT):
		var stage_type := _get_stage_type(i)
		var seed_value := stage_seed_rng.randi()
		var stage := stage_generator.generate(seed_value, stage_type)
		data.stages.append(stage)


func _get_stage_type(stage_index: int) -> StageGenerator.StageType:
	match stage_index:
		0:
			return StageGenerator.StageType.Start
		STAGE_COUNT - 1:
			return StageGenerator.StageType.Boss
		_:
			return StageGenerator.StageType.Inner


func _fill_passages(data : AreaData) -> void:
	for i in range(data.stages.size() - 1):
		var first_stage := data.stages[i]
		var second_stage := data.stages[i + 1]
		_fill_passages_for_pair(data, first_stage, second_stage)


func _fill_passages_for_pair(
	data : AreaData,
	first_stage: StageData,
	second_stage: StageData
) -> void:
	var first_size := first_stage.sectors.size()
	var second_size := second_stage.sectors.size()
	
	if first_size < second_size:
		_fill_passages_for_unequal_pair(
			data, first_stage.sectors, second_stage.sectors, _connect_sectors
		)
	elif first_size > second_size:
		_fill_passages_for_unequal_pair(
			data, second_stage.sectors, first_stage.sectors, _connect_sectors_flipped
		)
	else:
		_fill_passages_for_equal_pair(data, first_stage.sectors, second_stage.sectors)


func _fill_passages_for_equal_pair(
	data : AreaData,
	first_sectors: Array[SectorData],
	second_sectors: Array[SectorData]
) -> void:
	var size := first_sectors.size()
	
	for i in range(size):
		_connect_sectors(data, first_sectors, i, second_sectors, i)
	
	for i in range(size - 1):
		if _extra_passage_needed():
			var is_passage_fliped := _is_extra_passage_flipped()
			var from := i if is_passage_fliped else i + 1
			var to := i + 1 if is_passage_fliped else i
			_connect_sectors(data, first_sectors, from, second_sectors, to)


func _fill_passages_for_unequal_pair(
	data : AreaData,
	lesser_sectors: Array[SectorData],
	greater_sectors: Array[SectorData],
	connect_method: Callable
) -> void:
	var lesser_size := lesser_sectors.size()
	
	match lesser_size:
		1:
			_fill_passages_for_unequal_pair_1_to_2_3(
				data, lesser_sectors, greater_sectors, connect_method
			)
		2:
			_fill_passages_for_unequal_pair_2_to_3(
				data, lesser_sectors, greater_sectors, connect_method
			)


func _fill_passages_for_unequal_pair_1_to_2_3(
	data : AreaData,
	lesser_sectors: Array[SectorData],
	greater_sectors: Array[SectorData],
	connect_method: Callable
) -> void:
	var greater_size := greater_sectors.size()
	for i in range(greater_size):
		connect_method.call(data, lesser_sectors, 0, greater_sectors, i)
		


func _fill_passages_for_unequal_pair_2_to_3(
	data : AreaData,
	lesser_sectors: Array[SectorData],
	greater_sectors: Array[SectorData],
	connect_method: Callable
) -> void:

	connect_method.call(data, lesser_sectors, 0, greater_sectors, 0)
	connect_method.call(data, lesser_sectors, 1, greater_sectors, 2)
	
	if _extra_passage_needed():
		connect_method.call(data, lesser_sectors, 0, greater_sectors, 1)
		connect_method.call(data, lesser_sectors, 1, greater_sectors, 1)
	else:
		var from := 0 if _is_extra_passage_flipped() else 1
		connect_method.call(data, lesser_sectors, from, greater_sectors, 1)


func _extra_passage_needed() -> bool:
	return passage_chance_rng.randi_range(1, 100) <= EXTRA_PASSAGE_CHANCE


func _is_extra_passage_flipped() -> bool:
	return passage_direction_rng.randi_range(0, 1) == 0


func _connect_sectors(
	data : AreaData,
	first_sectors: Array[SectorData],
	first_index: int,
	second_sectors: Array[SectorData],
	second_index: int
) -> void:
	var seed_value := passage_seed_rng.randi()
	var passage := passage_generator.generate(seed_value)
	
	passage.type = _get_passage_type(
		first_sectors.size(), first_index,
		second_sectors.size(), second_index,
	)
	
	var first_sector := first_sectors[first_index]
	var second_sector := second_sectors[second_index]
	
	passage.previous_sector = first_sector
	passage.next_sector = second_sector
	
	first_sector.next_passages.append(passage)
	second_sector.previous_passages.append(passage)
	
	data.passages.append(passage)


func _connect_sectors_flipped(
	data : AreaData,
	first_sectors: Array[SectorData],
	first_index: int,
	second_sectors: Array[SectorData],
	second_index: int
) -> void:
	_connect_sectors(data, second_sectors, second_index, first_sectors, first_index)


func _get_passage_type(
		from_size: int, from_index: int, to_size: int, to_index: int
) -> PassageData.PassageType:
	var diff := from_index - to_index
	
	var key := "%d %d %d" % [from_size, to_size, diff]
	return PASSAGE_TYPES.get(key, PassageData.PassageType.ZeroGrad)
