extends AbstractReloader
class_name GatlingReloader


@export var firerate : int:
	set(value):
		firerate = value
		_calculate_delay()

@export var spin_out_time : int:
	set(value):
		spin_out_time = value
		_calculate_delay()


const INITIAL_DELAY = 1.0


var _target_delay : float
var _current_delay : float = INITIAL_DELAY
var _delay_decrement : float
var _cooldown : float
var _last_delta : float


func _ready() -> void:
	_calculate_delay()


func process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta
		
	if _current_delay < INITIAL_DELAY:
		_decrease_delay(_delay_decrement * -delta)
	
	_last_delta = delta


func can_shoot() -> bool:
	_decrease_delay(_delay_decrement * 2 * _last_delta)
	return _cooldown <= 0


func shoot() -> void:
	_cooldown = _current_delay


func reload() -> void:
	pass


func get_process_percent() -> int:
	return 100 - int(_cooldown * 100 / _current_delay)


func _calculate_delay() -> void:
	_target_delay = 60.0 / firerate
	_delay_decrement = (INITIAL_DELAY - _target_delay)/spin_out_time


func _decrease_delay(delay_decrement: float) -> void:
	_current_delay = _current_delay - delay_decrement
	_current_delay = clampf(_current_delay, _target_delay, INITIAL_DELAY)
