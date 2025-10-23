extends AbstractReloader


@export var magazine_size : int:
	set(value):
		magazine_size = value
		_calculate_bullets_in_magazine()


@export var reload_time : int:
	set(value):
		reload_time = value
		_calculate_reload_time_tenth()


var _bullets_in_magazine : int
var _reload_time_tenth : float
var _cooldown : float


func _ready() -> void:
	_calculate_bullets_in_magazine()
	_calculate_reload_time_tenth()


func _process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta
		if _cooldown <= 0:
			_bullets_in_magazine = magazine_size


func can_shoot() -> bool:
	return _bullets_in_magazine > 0


func shoot() -> void:
	if _bullets_in_magazine > 0:
		_bullets_in_magazine -= 1
	
	if _bullets_in_magazine == 0:
		reload()


func reload() -> void:
	if _cooldown > 0 or _bullets_in_magazine == magazine_size: return
	print("reload")
	var random_delay := _random.randf_range(-_reload_time_tenth, _reload_time_tenth)
	_cooldown = reload_time + random_delay


func _calculate_bullets_in_magazine() -> void:
	_bullets_in_magazine = magazine_size


func _calculate_reload_time_tenth() -> void:
	_reload_time_tenth = reload_time / 10.0
