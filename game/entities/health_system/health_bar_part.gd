class_name HealthBarPart
extends Control


const TICK_COUNT = 5


@export var texture_value : Texture2D
@export var texture_shade : Texture2D


var _tick_size : int = 0
var _target_value: float = 0


@onready var value_bar : TextureProgressBar = $ValueBar
@onready var shade_bar : TextureProgressBar = $ShadeBar

@onready var shade_delay_timer : Timer = $ShadeDelayTimer
@onready var shade_tick_timer : Timer = $ShadeTickTimer


func _ready() -> void:
	value_bar.texture_progress = texture_value
	shade_bar.texture_progress = texture_shade


func set_value(value: int) -> void:
	if value_bar.value == value: return
	
	value_bar.value = value
	if shade_bar.value < value_bar.value:
		shade_bar.value = value_bar.value
	else:
		shade_delay_timer.start()


func set_max_value(max_value: int) -> void:
	value_bar.max_value = max_value
	shade_bar.max_value = max_value
	
	if max_value == 0:
		value_bar.hide()
		shade_bar.hide()
	else:
		value_bar.show()
		shade_bar.show()


func _on_shade_delay_timer_timeout() -> void:
	var value_delta := shade_bar.value - value_bar.value
	_tick_size = ceil(value_delta / TICK_COUNT)
	_target_value = value_bar.value
	shade_tick_timer.start()


func _on_shade_tick_timer_timeout() -> void:
	shade_bar.value -= _tick_size
	if shade_bar.value <= _target_value:
		shade_bar.value = _target_value
		shade_tick_timer.stop()
