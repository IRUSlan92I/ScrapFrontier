class_name LaserProjectile
extends DirectHitProjectile


@onready var particles : GPUParticles2D = $GPUParticles2D


func _ready() -> void:
	super._ready()
	_update_sprite(_velocity)


func _update_sprite(velocity: Vector2) -> void:
	var angle := posmod(floor(rad_to_deg(velocity.angle())), 360)
	
	if angle > 90 and angle < 270:
		particles.process_material.direction = Vector3.RIGHT
	else:
		particles.process_material.direction = Vector3.LEFT
