extends AbstractReloader
class_name EnergyReloader


@export_range(1, 250) var heat_per_shot : int = 1:
	set(value):
		heat_per_shot = value
		_calculate_critical_heat()


@export_range(1, 2500) var heat_capacity : int = 1:
	set(value):
		heat_capacity = value
		_calculate_critical_heat()


@export_range(1, 5000) var cooling_down_rate : int = 1:
	set(value):
		cooling_down_rate = value
		_calculate_cool()


var _cool_per_sec : float
var _cool_per_sec_tenth : float


var _heat : float
var _critical_heat : int


func _ready() -> void:
	_calculate_critical_heat()
	_calculate_cool()


func process(delta: float) -> void:
	if _heat > 0:
		_heat -= _cool_per_sec * delta
		if _heat < 0:
			_heat = 0


func can_shoot() -> bool:
	return _heat <= _critical_heat


func shoot() -> void:
	_heat += heat_per_shot


func reload() -> void:
	pass


func get_process_percent() -> int:
	return 100 - int(_heat * 100 / heat_capacity)


func _calculate_critical_heat() -> void:
	_critical_heat = heat_capacity - heat_per_shot


func _calculate_cool() -> void:
	_cool_per_sec = cooling_down_rate / 60.0
	_cool_per_sec_tenth = _cool_per_sec / 10
