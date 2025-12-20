class_name AbstractRailgunProjectile
extends AbstractDirectHitProjectile


@export_range(1, 10) var piercing: int = 1


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	if piercing == 0:
		queue_free()
	else:
		piercing -= 1
