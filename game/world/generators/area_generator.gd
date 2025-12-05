class_name AreaGenerator
extends Node


@onready var stage_generator : StageGenerator = $StageGenerator
@onready var passage_generator : PassageGenerator = $PassageGenerator


const INNER_STAGE_COUNT = 3


func generate(seed_value: int) -> AreaData:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	
	var data : AreaData = AreaData.new()
	data.seed_value = seed_value
	
	_fill_stages(rng, data)
	_fill_passages(rng, data)
	
	return data


func _fill_stages(rng: RandomNumberGenerator, data : AreaData) -> void:
	_fill_first_stage(rng, data)
	_fill_last_stage(rng, data)
	_fill_inner_stages(rng, data)


func _fill_first_stage(rng: RandomNumberGenerator, data : AreaData) -> void:
	var stage := _get_stage(rng, true)
	data.first_stage = stage


func _fill_last_stage(rng: RandomNumberGenerator, data : AreaData) -> void:
	var stage := _get_stage(rng, true)
	data.last_stage = stage


func _fill_inner_stages(rng: RandomNumberGenerator, data : AreaData) -> void:
	for i in INNER_STAGE_COUNT:
		var stage := _get_stage(rng)
		data.inner_stages.append(stage)


func _fill_passages(rng: RandomNumberGenerator, data : AreaData) -> void:
	var all_stages : Array[StageData] = [data.first_stage] + data.inner_stages + [data.last_stage]

	for i in range(all_stages.size() - 1):
		var first_stage := all_stages[i]
		var second_stage := all_stages[i + 1]
		_fill_passages_for_pair(rng, data, first_stage, second_stage)


func _fill_passages_for_pair(
	rng: RandomNumberGenerator,
	data : AreaData,
	first_stage: StageData,
	second_stage: StageData
) -> void:
	var first_size := first_stage.sectors.size()
	var second_size := second_stage.sectors.size()
	
	if first_size == second_size:
		match first_size:
			1:
				pass
			2:
				pass
			3:
				pass
	else:
		var lesser_stage := first_stage if first_size < second_size else second_stage
		var greater_stage := first_stage if first_size > second_size else second_stage
		var lesser_size := lesser_stage.sectors.size()
		var greater_size := greater_stage.sectors.size()
		
		match lesser_size:
			1:
				match greater_size:
					2:
						pass
					3:
						pass
			2:
				pass


func _get_stage(rng: RandomNumberGenerator, is_endpoint: bool = false) -> StageData:
	var seed_value := rng.randi()
	var stage := stage_generator.generate(seed_value, is_endpoint)
	return stage
