extends Node2D

const TAP_MAX_DIST: float = 120.0
const POPUP_FONT = preload("res://assets/sprites/fonts/LoveYaLikeASister-Regular.ttf")

@onready var item_spawner: Node = $ItemSpawner
@onready var game_timer: Node = $GameTimer
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	ScoreManager.reset()
	game_timer.tick.connect(hud.on_tick)
	game_timer.time_up.connect(_on_time_up)
	hud.hint_finished.connect(_on_game_start)
	ScoreManager.score_applied.connect(_spawn_score_popup)


func _on_game_start() -> void:
	item_spawner.start()
	game_timer.start()


func _unhandled_input(event: InputEvent) -> void:
	var tap_pos: Vector2
	if event is InputEventScreenTouch and event.pressed:
		tap_pos = get_viewport().get_canvas_transform().affine_inverse() * event.position
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tap_pos = get_global_mouse_position()
	else:
		return

	var closest_item: Node = null
	var closest_dist: float = TAP_MAX_DIST

	for item in get_tree().get_nodes_in_group("items"):
		if not is_instance_valid(item) or item._swiped:
			continue
		var dist: float = item.position.distance_to(tap_pos)
		if dist < closest_dist:
			closest_dist = dist
			closest_item = item

	if closest_item != null:
		closest_item._on_tapped()


func _spawn_score_popup(amount: int, world_pos: Vector2) -> void:
	var label := Label.new()
	label.text = "+%d" % amount if amount > 0 else "%d" % amount
	label.add_theme_font_override("font", POPUP_FONT)
	label.add_theme_font_size_override("font_size", 52)
	var color := Color(0.3, 1.0, 0.35) if amount > 0 else Color(1.0, 0.25, 0.25)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.8))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.position = world_pos - Vector2(40, 60)
	add_child(label)
	var tween := create_tween()
	tween.tween_property(label, "position:y", label.position.y - 130.0, 1.1)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.1)
	tween.tween_callback(label.queue_free)


func _on_time_up() -> void:
	item_spawner.stop()
	hud.show_time_up()
	GameState.final_score = ScoreManager.score
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/ui/end_screen.tscn")
