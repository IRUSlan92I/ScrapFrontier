class_name BlinkChargeIndicator
extends Node2D


var maximum: float = 0:
	set = _set_maximum
	
var value: float = 0:
	set = _set_value


@onready var progress_bar : TextureProgressBar = $ProgressBar
@onready var charged_sprite : Sprite2D = $ChargedSprite


func _set_maximum(new_value: float) -> void:
	maximum = new_value
	value = clampf(value, 0, maximum)
	progress_bar.max_value = maximum
	_update_charged_sprite()


func _set_value(new_value: float) -> void:
	value = clampf(new_value, 0, maximum)
	progress_bar.value = value
	_update_charged_sprite()


func _update_charged_sprite() -> void:
	if is_equal_approx(value, maximum):
		charged_sprite.show()
	else:
		charged_sprite.hide()
