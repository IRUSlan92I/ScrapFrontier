extends Node2D

@export var size : Vector2


func _ready() -> void:
	var texture := PlaceholderTexture2D.new()
	texture.size = size
	$Sprite2D.texture = texture
