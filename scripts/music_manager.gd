extends Node

var _player: AudioStreamPlayer
var _muted: bool = false
var _mute_button: Button


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	var stream: AudioStreamOggVorbis = load("res://assets/sound/music_bg.ogg")
	stream.loop = true
	_player.stream = stream
	_player.volume_db = -6.0
	add_child(_player)
	_player.play()
	_setup_mute_button()


func _setup_mute_button() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 128
	add_child(canvas)

	_mute_button = Button.new()
	_mute_button.text = "♫"
	_mute_button.anchor_left = 1.0
	_mute_button.anchor_right = 1.0
	_mute_button.anchor_top = 1.0
	_mute_button.anchor_bottom = 1.0
	_mute_button.offset_left = -90.0
	_mute_button.offset_top = -70.0
	_mute_button.offset_right = -10.0
	_mute_button.offset_bottom = -10.0
	_mute_button.pressed.connect(_on_mute_pressed)
	canvas.add_child(_mute_button)


func _on_mute_pressed() -> void:
	_muted = not _muted
	_player.stream_paused = _muted
	_mute_button.text = "✕♫" if _muted else "♫"
