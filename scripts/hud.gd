extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var timer_label: Label = $TimerLabel

const FONT = preload("res://assets/sprites/fonts/LoveYaLikeASister-Regular.ttf")
const FONT_SIZE: int = 56


func _ready() -> void:
	for label in [score_label, timer_label]:
		label.add_theme_font_override("font", FONT)
		label.add_theme_font_size_override("font_size", FONT_SIZE)
	ScoreManager.score_changed.connect(_on_score_changed)
	_on_score_changed(ScoreManager.score)


func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score


func on_tick(remaining: float) -> void:
	var secs := ceili(remaining)
	timer_label.text = "%d:%02d" % [secs / 60, secs % 60]


func show_time_up() -> void:
	timer_label.text = "0:00"
