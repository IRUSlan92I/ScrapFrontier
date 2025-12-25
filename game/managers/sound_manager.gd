class_name CSoundManager
extends Node


const MASTER_BUS = "Master"
const UI_BUS = "UI"
const SFX_BUS = "SFX"
const MUSIC_BUS = "Music"


enum UISound {
	UI_ACCEPT,
	UI_DECLINE,
	UI_NEXT,
	UI_PREVIOUS,
}

enum SFXSound {
	
}

enum Music {
	
}


@export_group("Number of players", "player_count")
@export_range(1, 10) var player_count_ui := 1
@export_range(1, 100) var player_count_sfx := 1

@export_group("UI Sounds", "ui")
@export var ui_accept : AudioStream
@export var ui_decline : AudioStream
@export var ui_next : AudioStream
@export var ui_previous : AudioStream


var ui_players : Array[AudioStreamPlayer] = []
var sfx_players : Array[AudioStreamPlayer2D] = []
var music_player : AudioStreamPlayer


func _ready() -> void:
	_create_ui_players()
	_create_sfx_players()
	_create_music_player()


func play_ui_sound(sound: UISound) -> void:
	pass


func play_sfx_sound(sound: SFXSound) -> void:
	pass


func play_music(music: Music) -> void:
	pass


func _create_ui_players() -> void:
	for i in range(player_count_ui):
		var player : AudioStreamPlayer = AudioStreamPlayer.new()
		player.bus = UI_BUS
		ui_players.append(player)


func _create_sfx_players() -> void:
	for i in range(player_count_sfx):
		var player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
		player.bus = SFX_BUS
		sfx_players.append(player)


func _create_music_player() -> void:
	var player : AudioStreamPlayer = AudioStreamPlayer.new()
	player.bus = MUSIC_BUS
	music_player = player
