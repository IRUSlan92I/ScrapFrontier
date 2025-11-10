class_name EnemyController
extends Node

@warning_ignore("unused_signal")
signal accelerate(direction: Vector2, delta: float)

@warning_ignore("unused_signal")
signal shoot(weapon_index: int)


@warning_ignore("unused_signal")
signal reload(weapon_index: int)


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	for i in 10:
		shoot.emit(i)
