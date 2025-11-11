extends Control


signal back


@onready var main_menu_button := $%BackButton


func _ready() -> void:
	main_menu_button.grab_focus()


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	main_menu_button.grab_focus()

func _on_back_button_pressed() -> void:
	back.emit()
