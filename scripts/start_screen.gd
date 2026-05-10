extends Node2D

@onready var waffles_frame: Panel = $UI/WafflesFrame
@onready var prince_frame: Panel = $UI/PrinceFrame
@onready var waffles_button: TextureButton = $UI/WafflesButton
@onready var prince_button: TextureButton = $UI/PrinceButton
@onready var play_button: TextureButton = $UI/PlayButton
@onready var title_label: Label = $UI/TitleLabel
@onready var select_label: Label = $UI/SelectLabel
@onready var waffles_label: Label = $UI/WafflesLabel
@onready var prince_label: Label = $UI/PrinceLabel

const FONT = preload("res://assets/sprites/fonts/LoveYaLikeASister-Regular.ttf")


func _ready() -> void:
	title_label.add_theme_font_override("font", FONT)
	title_label.add_theme_font_size_override("font_size", 96)
	for label: Label in [select_label, waffles_label, prince_label]:
		label.add_theme_font_override("font", FONT)
		label.add_theme_font_size_override("font_size", 56)
	waffles_button.pressed.connect(_on_waffles_pressed)
	prince_button.pressed.connect(_on_prince_pressed)
	play_button.pressed.connect(_on_play_pressed)
	_update_selection()


func _on_waffles_pressed() -> void:
	GameState.selected_cat = 0
	_update_selection()


func _on_prince_pressed() -> void:
	GameState.selected_cat = 1
	_update_selection()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _update_selection() -> void:
	waffles_frame.visible = GameState.selected_cat == 0
	prince_frame.visible = GameState.selected_cat == 1
