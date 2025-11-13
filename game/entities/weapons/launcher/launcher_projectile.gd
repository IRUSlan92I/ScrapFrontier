class_name LauncherProjectile
extends AbstractProjectile


@export_range(0, 360) var rotation_speed: int


@onready var sprites : Array[Sprite2D] = [
	$Sprite2D_E, $Sprite2D_SE, $Sprite2D_S, $Sprite2D_SW,
	$Sprite2D_W, $Sprite2D_NW, $Sprite2D_N, $Sprite2D_NE,
]

var target : AbstractShip = null


func _ready() -> void:
	_acquire_target()
	super._ready()
	_update_sprite(_velocity)


func _physics_process(delta: float) -> void:
	_apply_homing_guidance(delta)
	super._physics_process(delta)


func _acquire_target() -> void:
	target = _get_nearest_foe()


func _apply_homing_guidance(delta: float) -> void:
	if not target: return
	
	var max_angle_change := deg_to_rad(rotation_speed) * delta
	
	var current_angle := _velocity.angle()
	var target_angle := (target.position - position).angle()
	
	var angle_diff := wrapf(target_angle - current_angle, -PI, PI)
	var angle_change := clampf(angle_diff, -max_angle_change, max_angle_change)
	_velocity = _velocity.rotated(angle_change)
	
	_update_sprite(_velocity)


func _update_sprite(velocity: Vector2) -> void:
	var sector := TAU / sprites.size()
	var angle := velocity.angle()
	var bisector := angle + sector * 0.5
	
	var index := floori(fposmod(bisector, TAU) / sector)
	
	for sprite in sprites:
		sprite.hide()
	
	sprites[index].show()
