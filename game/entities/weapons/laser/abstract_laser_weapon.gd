class_name AbstractLaserWeapon
extends AbstractWeapon


@export var damage : AbstractDamage
@export_range(-100.0, 100.0) var line_texture_speed := 7.0


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer : Timer = $CooldownTimer
@onready var ray_cast : RayCast2D = $RayCast2D
@onready var line : Line2D = $Line2D
@onready var hit_particles : GPUParticles2D = $HitParticles


func _ready() -> void:
	sprite.play(SHOT_ANIMATION)


func _process(_delta: float) -> void:
	var collision_point: Vector2
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		collision_point = ray_cast.get_collision_point() - global_position
		hit_particles.position = collision_point
		hit_particles.show()
	else:
		collision_point = muzzle.position + ray_cast.target_position
		hit_particles.hide()
	
	line.clear_points()
	line.add_point(muzzle.position)
	line.add_point(collision_point)


func shoot(_ship_velocity: Vector2) -> bool:
	if not _can_shoot: return false
	
	if ray_cast.is_colliding():
		AbstractProjectile._try_to_damage(ray_cast.get_collider(), damage)
	
	_can_shoot = false
	cooldown_timer.start()
	return true


func _on_cooldown_timer_timeout() -> void:
		_can_shoot = true
