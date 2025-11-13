class_name LauncherProjectile
extends AbstractProjectile


@onready var sprites : Array[Sprite2D] = [
	$Sprite2D_E, $Sprite2D_SE, $Sprite2D_S, $Sprite2D_SW,
	$Sprite2D_W, $Sprite2D_NW, $Sprite2D_N, $Sprite2D_NE,
]


func _ready() -> void:
	super._ready()
	_update_sprite(_velocity)


func _update_sprite(velocity: Vector2) -> void:
	var sector := 360.0 / sprites.size()
	var angle := rad_to_deg(velocity.angle())
	var bisector := floori(angle + sector * 0.5)
	
	var index := floori(posmod(bisector, 360) / sector)
	
	for sprite in sprites:
		sprite.hide()
	
	sprites[index].show()
