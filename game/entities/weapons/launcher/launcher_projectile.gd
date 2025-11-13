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
	target = _get_nearest_foe([])


func _apply_homing_guidance(delta: float) -> void:
	if not target: return
	
	var max_rotation_speed := deg_to_rad(rotation_speed) * delta
	
	var angle := (_velocity + position - target.position).angle()
	
	_velocity = _velocity.rotated(angle)
	
	_update_sprite(_velocity)


func _update_sprite(velocity: Vector2) -> void:
	var sector := 360.0 / sprites.size()
	var angle := rad_to_deg(velocity.angle())
	var bisector := floori(angle + sector * 0.5)
	
	var index := floori(posmod(bisector, 360) / sector)
	
	for sprite in sprites:
		sprite.hide()
	
	sprites[index].show()
