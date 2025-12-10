class_name PlayerShip
extends AbstractShip


const ENEMY_LAYER = 4

const BLINK_CHARGE_MAXIMUM = 3.0


@export_range(0, 200) var blink_range := 0


var blink_charge: float:
	set(value):
		blink_charge = value
		if blink_charge_indicator != null:
			blink_charge_indicator.value = blink_charge


@onready var blink_shadow : GPUParticles2D = $BlinkShadow
@onready var blink_charge_indicator : BlinkChargeIndicator = $BlinkChargeIndicator


func _ready() -> void:
	super._ready()
	
	blink_charge_indicator.maximum = BLINK_CHARGE_MAXIMUM
	blink_charge = BLINK_CHARGE_MAXIMUM
	
	for weapon_position in weapon_positions:
		var weapon : AbstractWeapon = WEAPONS.pick_random().instantiate()
		_add_weapon(weapon, weapon_position)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if blink_charge < BLINK_CHARGE_MAXIMUM:
		blink_charge += delta
		blink_charge_indicator.value = blink_charge


func _add_weapon(weapon: AbstractWeapon, weapon_position: Vector2) -> void:
	super._add_weapon(weapon, weapon_position)
	weapon.set_belonging(AbstractWeapon.Belonging.PLAYER)


func _blink(direction: Vector2) -> void:
	if blink_charge < BLINK_CHARGE_MAXIMUM: return
	
	blink_charge = 0
	
	var shadow : GPUParticles2D = blink_shadow.duplicate()
	var process_material : ParticleProcessMaterial = shadow.process_material
	process_material.direction = Vector3(direction.x, direction.y, 0)
	
	shadow.emitting = true
	shadow.global_position = global_position
	get_tree().current_scene.add_child(shadow)
	shadow.finished.connect(shadow.queue_free)
	
	collision_mask &= ~ENEMY_LAYER
	move_and_collide(direction * blink_range)
	collision_mask |= ENEMY_LAYER
