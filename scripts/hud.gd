extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var timer_label: Label = $TimerLabel
@onready var hint_label: Label = $HintLabel
@onready var start_hint_label: Label = $StartHintLabel
@onready var start_hint_bg: ColorRect = $StartHintBg

const FONT = preload("res://assets/sprites/fonts/LoveYaLikeASister-Regular.ttf")
const FONT_SIZE: int = 56


func _ready() -> void:
	for label: Label in [score_label, timer_label, hint_label, start_hint_label]:
		label.add_theme_font_override("font", FONT)
		label.add_theme_font_size_override("font_size", FONT_SIZE)
	hint_label.add_theme_color_override("font_color", Color(1, 0.3, 0.2))
	start_hint_label.add_theme_color_override("font_color", Color(1, 1, 0.6))
	ScoreManager.score_changed.connect(_on_score_changed)
	ScoreManager.first_nonfood_dog_hit.connect(_show_hint)
	_on_score_changed(ScoreManager.score)
	_show_start_hint()


func _show_start_hint() -> void:
	start_hint_label.visible = true
	start_hint_bg.visible = true
	await get_tree().create_timer(4.0).timeout
	start_hint_label.visible = false
	start_hint_bg.visible = false


func _show_hint() -> void:
	hint_label.visible = true
	await get_tree().create_timer(3.0).timeout
	hint_label.visible = false


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func on_tick(remaining: float) -> void:
	var secs := ceili(remaining)
	timer_label.text = "%d:%02d" % [secs / 60, secs % 60]
	if remaining <= 10.0:
		timer_label.add_theme_color_override("font_color", Color(1, 0.15, 0.15))
	else:
		timer_label.remove_theme_color_override("font_color")


func show_time_up() -> void:
	timer_label.text = "0:00"
