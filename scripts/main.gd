extends Node2D

@onready var item_spawner: Node = $ItemSpawner
@onready var game_timer: Node = $GameTimer
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	ScoreManager.reset()
	game_timer.tick.connect(hud.on_tick)
	game_timer.time_up.connect(_on_time_up)
	game_timer.start()


func _on_time_up() -> void:
	item_spawner.stop()
	hud.show_time_up()
	GameState.final_score = ScoreManager.score
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/end_screen.tscn")
