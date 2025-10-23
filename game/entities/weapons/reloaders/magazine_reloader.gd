extends AbstractReloader


@export var magazine_size : int
@export var reload_time : int


@onready var _bullets_in_magazine : int = magazine_size if magazine_size > 0 else -1
@onready var _reload_time_tenth : float = reload_time / 10.0


var _cooldown : float


func _process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta
	
	if _bullets_in_magazine == 0 and _cooldown <= 0:
		_bullets_in_magazine = magazine_size


func can_shoot() -> bool:
	return _bullets_in_magazine > 0


func shoot() -> void:
	if _bullets_in_magazine > 0:
		_bullets_in_magazine -= 1
	
	if _bullets_in_magazine == 0:
		var random_delay := random.randf_range(-_reload_time_tenth, _reload_time_tenth)
		_cooldown = reload_time + random_delay
