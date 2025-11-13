class_name ShrapnelProjectile
extends AbstractProjectile


@export var max_distance : int


var _traveled_distance: float


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_process_distance(delta)


func _process_distance(delta: float) -> void:
	_traveled_distance += _velocity.length() * delta
	if max_distance > 0 and _traveled_distance > max_distance:
		queue_free()
