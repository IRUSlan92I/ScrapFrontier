extends AbstractProjectile


@export var deceleration : int
@export var livetime : int


func _ready() -> void:
	super._ready()
	
	var livetime_timer := Timer.new()
	add_child(livetime_timer)
	livetime_timer.wait_time = livetime
	livetime_timer.one_shot = true
	livetime_timer.timeout.connect(queue_free)
	livetime_timer.start()


func _physics_process(delta: float) -> void:
	_process_acceleration(delta)
	super._physics_process(delta)


func _process_acceleration(delta: float) -> void:
	var current_deceleration := deceleration * delta
	if _velocity.length() > current_deceleration:
		_velocity -= _velocity.normalized() * current_deceleration
	else:
		_velocity = Vector2.ZERO
