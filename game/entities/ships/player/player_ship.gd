class_name PlayerShip
extends AbstractShip


@export_range(0, 200) var blink_range := 0


@onready var blink_timer : Timer = $BlinkTimer
@onready var blink_shadow : GPUParticles2D = $BlinkShadow


func _ready() -> void:
	super._ready()
	for weapon in _weapons:
		weapon.set_belonging(AbstractWeapon.Belonging.PLAYER)


func _on_player_controller_shoot(weapon_index: int) -> void:
	if weapon_index >= _weapons.size(): return
	
	_weapons[weapon_index].shoot(velocity)


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
