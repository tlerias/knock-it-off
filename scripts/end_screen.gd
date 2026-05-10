extends Node2D

@onready var message_label: Label = $UI/MessageLabel
@onready var score_label: Label = $UI/ScoreLabel
@onready var play_again_button: TextureButton = $UI/PlayAgainButton

const FONT = preload("res://assets/sprites/fonts/LoveYaLikeASister-Regular.ttf")


func _ready() -> void:
	message_label.add_theme_font_override("font", FONT)
	message_label.add_theme_font_size_override("font_size", 72)
	score_label.add_theme_font_override("font", FONT)
	score_label.add_theme_font_size_override("font_size", 64)
	score_label.text = "Score: %d" % GameState.final_score
	play_again_button.pressed.connect(_on_play_again_pressed)


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")
