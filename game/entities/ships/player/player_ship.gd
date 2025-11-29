class_name PlayerShip
extends AbstractShip


@export_range(0, 200) var blink_range := 0


@onready var blink_timer : Timer = $BlinkTimer
@onready var blink_shadow : GPUParticles2D = $BlinkShadow


func _ready() -> void:
	super._ready()
	
	for weapon_position in weapon_positions:
		var weapon : AbstractWeapon = WEAPONS.pick_random().instantiate()
		_add_weapon(weapon, weapon_position)


func _add_weapon(weapon: AbstractWeapon, weapon_position: Vector2) -> void:
	super._add_weapon(weapon, weapon_position)
	weapon.set_belonging(AbstractWeapon.Belonging.PLAYER)


func _blink(direction: Vector2) -> void:
	if not blink_timer.is_stopped(): return
	
	blink_timer.start()
	
	var shadow : GPUParticles2D = blink_shadow.duplicate()
	var process_material : ParticleProcessMaterial = shadow.process_material
	process_material.direction = Vector3(direction.x, direction.y, 0)
	
	shadow.emitting = true
	shadow.global_position = global_position
	get_tree().current_scene.add_child(shadow)
	shadow.finished.connect(shadow.queue_free)
	
	move_and_collide(direction * blink_range)
