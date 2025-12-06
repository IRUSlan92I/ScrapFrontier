class_name AreaGenerator
extends Node


@onready var stage_generator : StageGenerator = $StageGenerator
@onready var passage_generator : PassageGenerator = $PassageGenerator


const STAGE_COUNT = 9

const EXTRA_PASSAGE_CHANCE = 20


var local_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var stage_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_seed_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_chance_rng : RandomNumberGenerator = RandomNumberGenerator.new()
var passage_direction_rng : RandomNumberGenerator = RandomNumberGenerator.new()


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
		var is_endpoint := i == 0 or i == STAGE_COUNT - 1
		var seed_value := stage_seed_rng.randi()
		var stage := stage_generator.generate(seed_value, is_endpoint)
		data.stages.append(stage)


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
		var is_flipped := false
		_fill_passages_for_unequal_pair(data, first_stage.sectors, second_stage.sectors, is_flipped)
	elif first_size > second_size:
		var is_flipped := true
		_fill_passages_for_unequal_pair(data, second_stage.sectors, first_stage.sectors, is_flipped)
	else:
		_fill_passages_for_equal_pair(data, first_stage.sectors, second_stage.sectors)


func _fill_passages_for_equal_pair(
	data : AreaData,
	first_sectors: Array[SectorData],
	second_sectors: Array[SectorData]
) -> void:
	var size := first_sectors.size()
	
	for i in range(size):
		_connect_sectors(data, first_sectors[i], second_sectors[i])
	
	for i in range(size - 1):
		if _extra_passage_needed():
			var is_passage_fliped := _is_extra_passage_flipped()
			var from := i if is_passage_fliped else i + 1
			var to := i + 1 if is_passage_fliped else i
			_connect_sectors(data, first_sectors[from], second_sectors[to])


func _fill_passages_for_unequal_pair(
	data : AreaData,
	lesser_sectors: Array[SectorData],
	greater_sectors: Array[SectorData],
	is_sectors_flipped: bool
) -> void:
	var lesser_size := lesser_sectors.size()
	var greater_size := greater_sectors.size()
	
	match lesser_size:
		1:
			for i in range(greater_size):
				_connect_sectors(data, lesser_sectors[0], greater_sectors[i], is_sectors_flipped)
		2:
			_connect_sectors(data, lesser_sectors[0], greater_sectors[0], is_sectors_flipped)
			_connect_sectors(data, lesser_sectors[1], greater_sectors[2], is_sectors_flipped)
			if _extra_passage_needed():
				_connect_sectors(data, lesser_sectors[0], greater_sectors[1], is_sectors_flipped)
				_connect_sectors(data, lesser_sectors[1], greater_sectors[1], is_sectors_flipped)
			else:
				var from := 0 if _is_extra_passage_flipped() else 1
				_connect_sectors(data, lesser_sectors[from], greater_sectors[1], is_sectors_flipped)


func _extra_passage_needed() -> bool:
	return passage_chance_rng.randi_range(1, 100) <= EXTRA_PASSAGE_CHANCE


func _is_extra_passage_flipped() -> bool:
	return passage_direction_rng.randi_range(0, 1) == 0


func _connect_sectors(
	data : AreaData,
	first_sector: SectorData,
	second_sector: SectorData,
	is_flipped: bool = false
) -> void:
	var seed_value := passage_seed_rng.randi()
	var passage := passage_generator.generate(seed_value)
	
	var previous_sector := second_sector if is_flipped else first_sector
	var next_sector := first_sector if is_flipped else second_sector
	
	passage.previous_sector = previous_sector
	passage.next_sector = next_sector
	
	previous_sector.next_passages.append(passage)
	next_sector.previous_passages.append(passage)
	
	data.passages.append(passage)
