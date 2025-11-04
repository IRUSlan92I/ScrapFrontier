extends AbstractProjectile


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(6, 6)
	$Sprite2D.texture = texture
	
	super._ready()
