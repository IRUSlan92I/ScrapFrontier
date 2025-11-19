class_name EnemyController
extends Node

signal accelerate(direction: Vector2, delta: float)
signal shoot(weapon_index: int)
signal reload(weapon_index: int)


func _physics_process(delta: float) -> void:
	for i in 10:
		shoot.emit(i)
	accelerate.emit(Vector2.ZERO, delta)
