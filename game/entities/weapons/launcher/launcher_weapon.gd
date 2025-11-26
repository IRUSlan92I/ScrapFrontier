extends AbstractWeapon


@onready var player_sprite : Sprite2D = $PlayerSprite
@onready var enemy_sprite : Sprite2D = $EnemySprite
@onready var cooldown_timer : Timer = $CooldownTimer

@onready var particles : Array[GPUParticles2D] = [
	$RightParticles, $LeftParticles,
]
var _particles_index := 0

@onready var muzzles : Array[Node2D] = [
	$RightMuzzle, $LeftMuzzle,
]
var _muzzle_index := 0


func set_belonging(belonging: Belonging) -> void:
	super.set_belonging(belonging)
	
	match _belonging:
		Belonging.PLAYER:
			player_sprite.show()
			enemy_sprite.hide()
		Belonging.ENEMY:
			player_sprite.hide()
			enemy_sprite.show()


func shoot(ship_velocity: Vector2) -> bool:
	var is_shot := super.shoot(ship_velocity)
	if is_shot:
		_can_shoot = false
		cooldown_timer.start()
		_restart_particles()
	
	return is_shot


func _restart_particles() -> void:
	var particle : GPUParticles2D = null
	
	particle = _get_particle()
	
	if particle != null:
		particle.restart()


func _get_projectile_position() -> Vector2:
	var projectile_position := muzzles[_muzzle_index].position
	_muzzle_index += 1
	if _muzzle_index >= muzzles.size():
		_muzzle_index = 0
	return projectile_position


func _get_particle() -> GPUParticles2D:
	var particle := particles[_particles_index]
	_particles_index += 1
	if _particles_index >= particles.size():
		_particles_index = 0
	return particle


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
