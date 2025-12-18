extends Control


signal back


@export var scroll_speed: float = 25.0


@onready var main_menu_button := $BackButton
@onready var text := $Text
@onready var tween: Tween


func _ready() -> void:
	main_menu_button.grab_focus()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	main_menu_button.grab_focus()
	
	_start_scrolling()


func _start_scrolling() -> void:
	var start_pos := Vector2(0, get_viewport_rect().size.y)
	var end_pos := Vector2(0, -text.size.y)
	var duration := (start_pos.y - end_pos.y) / scroll_speed
	
	text.position = start_pos
	
	tween = create_tween()
	tween.tween_property(text, "position:y", end_pos.y, duration)
	tween.finished.connect(_on_scroll_finished)


func _on_back_button_pressed() -> void:
	if tween:
		tween.kill()
	
	back.emit()


func _on_scroll_finished() -> void:
	back.emit()
