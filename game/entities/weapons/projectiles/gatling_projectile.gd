extends AbstractProjectile


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(4, 4)
	$Sprite2D.texture = texture
	
	super._ready()


func _physics_process(delta: float) -> void:
	move(delta)
