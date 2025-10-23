extends AbstractReloader


@export var firerate : int


@onready var _delay : float = 60.0 / firerate
@onready var _delay_tenth : float = _delay / 10


var _cooldown : float


func _process(delta: float) -> void:
	if _cooldown > 0:
		_cooldown -= delta


func can_shoot() -> bool:
	return _cooldown <= 0


func shoot() -> void:
	var random_delay := random.randf_range(-_delay_tenth, _delay_tenth)
	_cooldown = _delay + random_delay
