extends AbstractWeapon


@onready var player_sprite : Sprite2D = $PlayerSprite
@onready var enemy_sprite : Sprite2D = $EnemySprite
@onready var cooldown_timer : Timer = $CooldownTimer

@onready var player_particles : Array[GPUParticles2D] = [
	$ShotProjectiles/PlayerRightParticles, $ShotProjectiles/PlayerLeftParticles,
]
@onready var enemy_particles : Array[GPUParticles2D] = [
	$ShotProjectiles/EnemyRightParticles, $ShotProjectiles/EnemyLeftParticles,
]
var _particles_index := 0

const PLAYER_PROJECTILE_POSITIONS : Array[Vector2] = [
	Vector2(4, 3), Vector2(4, -3),
]
const ENEMY_PROJECTILE_POSITIONS : Array[Vector2] = [
	Vector2(-4, 3), Vector2(-4, -3),
]
var _projectile_position_index := 0


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
	
	match _belonging:
		Belonging.PLAYER:
			particle = _get_particle_from_array(player_particles)
		Belonging.ENEMY:
			particle = _get_particle_from_array(enemy_particles)
	
	if particle != null:
		particle.restart()


func _get_projectile_position() -> Vector2:
	var projectile_position : Vector2
	
	match _belonging:
		Belonging.PLAYER:
			projectile_position = _get_projectile_position_from_array(PLAYER_PROJECTILE_POSITIONS)
		Belonging.ENEMY:
			projectile_position = _get_projectile_position_from_array(ENEMY_PROJECTILE_POSITIONS)
	
	return projectile_position


func _get_particle_from_array(array: Array[GPUParticles2D]) -> GPUParticles2D:
	var particle := array[_particles_index]
	_particles_index += 1
	if _particles_index >= array.size():
		_particles_index = 0
	return particle


func _get_projectile_position_from_array(array: Array[Vector2]) -> Vector2:
	var projectile_position := array[_projectile_position_index]
	_projectile_position_index += 1
	if _projectile_position_index >= array.size():
		_projectile_position_index = 0
	return projectile_position


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
