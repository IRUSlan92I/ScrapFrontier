class_name AbstractShip
extends CharacterBody2D


signal destroyed


const SHADER_INTENSITY = "shader_parameter/intensity"


@export_range(0, 250) var acceleration : int = 0
@export_range(0, 250) var deceleration : int = 0
@export_range(0, 250) var max_speed : int = 0
@export_range(0, 1000) var mass : int = 0

@export_range(0, 360) var weapon_rotation : int = 0


var weapon_positions: Array[Vector2]

var _weapons : Array[AbstractWeapon]


@onready var ship : Node2D = $Ship
@onready var ship_sprite : Sprite2D = $ShipSprite
@onready var armor_sprite : Sprite2D = $ArmorSprite
@onready var shield_sprite : Sprite2D = $ShieldSprite

@onready var health_bar : HealthBar = $HealthBar

@onready var debris_particles : GPUParticles2D = $DebrisParticles

@onready var health : Health = $Health


func _ready() -> void:
	for slot in $WeaponSlots.get_children():
		if slot is Node2D:
			weapon_positions.append(slot.global_position - global_position)
	
	_on_shield_updated(health.shield, health.max_shield)
	_on_armor_updated(health.armor, health.max_armor)
	_on_hull_updated(health.hull, health.max_hull)


func _physics_process(_delta: float) -> void:
	var was_collided := move_and_slide()
	if was_collided:
		for i in get_slide_collision_count():
			var collider := get_slide_collision(i).get_collider()
			if collider is AbstractShip:
				var other_ship := collider as AbstractShip
				var momentum := mass * velocity
				var collider_momentum := other_ship.mass * other_ship.velocity
				var total_mass := mass + other_ship.mass
				
				var new_velocity := (momentum + collider_momentum)/total_mass
				other_ship.velocity = new_velocity
				velocity = new_velocity
		
		var normal := get_wall_normal()
		velocity -= normal.abs() * velocity


func accelerate(direction: Vector2, delta: float) -> void:
	var accel : Vector2 = direction * acceleration * delta
	var decel : float = deceleration * delta
	
	velocity.x = _get_new_speed(accel.x, decel, velocity.x)
	velocity.y = _get_new_speed(accel.y, decel, velocity.y)

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed


func shoot() -> void:
	for weapon in _weapons:
		weapon.shoot(velocity)


func _get_new_speed(accel: float, decel: float, current_speed: float) -> float:
	if is_zero_approx(accel):
		if absf(current_speed) < decel:
			return 0.0
		return current_speed + (decel if current_speed < 0 else -decel)
	else:
		return current_speed + accel


func _on_health_depleted() -> void:
	for weapon in _weapons:
		weapon.queue_free()
	_weapons.clear()
	ship_sprite.hide()
	armor_sprite.hide()
	shield_sprite.hide()
	health_bar.hide()
	debris_particles.emitting = true


func _add_weapon(weapon: AbstractWeapon, weapon_position: Vector2) -> void:
	weapon.position = weapon_position
	add_child(weapon)
	_weapons.append(weapon)


func _on_shield_updated(value: int, max_value: int) -> void:
	if shield_sprite == null: return
	
	shield_sprite.visible = value != 0
	var intensity := value/float(max_value) if value != 0 else 0.0
	shield_sprite.material.set(SHADER_INTENSITY, intensity)


func _on_armor_updated(value: int, max_value: int) -> void:
	if armor_sprite == null: return
	
	armor_sprite.visible = value != 0
	var intensity := value/float(max_value) if value != 0 else 0.0
	armor_sprite.material.set(SHADER_INTENSITY, intensity)


func _on_hull_updated(_value: int, _max_value: int) -> void:
	pass


func _on_debris_particles_finished() -> void:
	queue_free()
	destroyed.emit()
