extends AbstractWeapon


@onready var sprite := $Sprite2D


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(10, 7)
	sprite.texture = texture
	
	super._ready()
