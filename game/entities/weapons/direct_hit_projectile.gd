class_name DirectHitProjectile
extends AbstractProjectile


@export var damage : AbstractDamage


func _on_body_entered(body: Node2D) -> void:
	if _try_to_damage(body, damage):
		_process_hit_for_projectile(body)
