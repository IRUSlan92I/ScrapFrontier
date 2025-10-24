extends AbstractReloader


@export var firerate : int:
	set(value):
		firerate = value
		_calculate_delay()


var _delay : float
var _delay_tenth : float
var _cooldown : float


func _ready() -> void:
	_calculate_delay()


func _physics_process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta


func can_shoot() -> bool:
	return _cooldown <= 0


func shoot() -> void:
	var random_delay := _random.randf_range(-_delay_tenth, _delay_tenth)
	_cooldown = _delay + random_delay


func reload() -> void:
	pass


func get_process_percent() -> int:
	return 100 - int(_cooldown * 100 / _delay)


func _calculate_delay() -> void:
	_delay = 60.0 / firerate
	_delay_tenth = _delay / 10
