class_name CannonProjectile
extends BlastProjectile


@onready var sprite : Sprite2D = $Sprite2D
@onready var explosion_particles : ExplosionParticles = $ExplosionParticles


func _process_hit_for_projectile(_collided_body: Node2D) -> void:
	sprite.hide()
	explosion_particles.emitting = true
	set_physics_process(false)
	collision_mask = 0
	blast.collision_mask = 0


func _on_explosion_particles_finished() -> void:
	queue_free()
