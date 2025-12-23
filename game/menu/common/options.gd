extends Control


const WINDOW_FACTOR = "window_factor"


signal show_credits
signal back


@onready var fullscreen_button : CheckButton = $%FullscreenCheckButton
@onready var window_factor_buttons : HBoxContainer = $%WindowFactorContainer
@onready var credits_button : Button = $%CreditsButton
@onready var back_button : Button = $%BackButton
@onready var master_slider : Slider = $%MasterSlider
@onready var menu_slider : Slider = $%MenuSlider
@onready var sfx_slider : Slider = $%SFXSlider
@onready var music_slider : Slider = $%MusicSlider


func _ready() -> void:
	_connect_window_factor_buttons()
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _connect_window_factor_buttons() -> void:
	for child in window_factor_buttons.get_children():
		if child is Button:
			var button : Button = child
			button.pressed.connect(_on_window_factor_button_pressed.bind(button))


func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	if not visible: return
	
	_load_current_settings()
	_init_focus()
	_setup_neighbors()


func _init_focus() -> void:
	fullscreen_button.grab_focus()


func _setup_neighbors() -> void:
	music_slider.focus_neighbor_bottom = back_button.get_path()
	back_button.focus_neighbor_right = credits_button.get_path()
	credits_button.focus_neighbor_left = back_button.get_path()


func _load_current_settings() -> void:
	print(SettingsManager.window_factor)
	fullscreen_button.button_pressed = SettingsManager.fullscreen
	for child in window_factor_buttons.get_children():
		if child is Button:
			var button : Button = child
			var window_factor : int = button.get_meta(WINDOW_FACTOR, 0)
			print(window_factor)
			if window_factor == SettingsManager.window_factor:
				button.button_pressed = true
				print(button)
	_update_window_factor_disabled()


func _update_window_factor_disabled() -> void:
	for child in window_factor_buttons.get_children():
		if child is Button:
			child.disabled = SettingsManager.fullscreen


func _on_fullscreen_check_button_toggled(toggled: bool) -> void:
	SettingsManager.fullscreen = toggled
	_update_window_factor_disabled()


func _on_credits_button_pressed() -> void:
	show_credits.emit()


func _on_back_button_pressed() -> void:
	back.emit()


func _on_window_factor_button_pressed(button: Button) -> void:
	var window_factor : int = button.get_meta(WINDOW_FACTOR, 0)
	if window_factor > 0:
		SettingsManager.window_factor = window_factor
