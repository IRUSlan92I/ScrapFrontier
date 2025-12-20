class_name AbstractBlastProjectile
extends AbstractProjectile


@onready var blast : Blast = $Blast


func _on_body_entered(body: Node2D) -> void:
	var damaged := _try_to_damage_by_blast()
	if damaged:
		_process_hit_for_projectile(body)


func _try_to_damage_by_blast() -> bool:
	var damaged := false
	var overlapping_bodies := blast.get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		var damage := blast.get_damage_to(overlapping_body)
		if _try_to_damage(overlapping_body, damage):
			damaged = true
	return damaged
