extends Node2D


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = Vector2(10, 7)
	$Sprite2D.texture = texture


func shoot() -> void:
	print("shoot")
