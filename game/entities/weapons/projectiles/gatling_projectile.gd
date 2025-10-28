extends CharacterBody2D


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(4, 4)
	$Sprite2D.texture = texture
