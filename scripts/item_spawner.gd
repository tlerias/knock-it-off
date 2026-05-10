extends Node

@export var spawn_interval_min: float = 0.25
@export var spawn_interval_max: float = 0.55
@export var spawn_x_min: float = 300.0
@export var spawn_x_max: float = 1700.0
@export var spawn_y: float = 406.0

const ITEM_SCENE = preload("res://scenes/item.tscn")
const Item = preload("res://scripts/item.gd")

const FOOD_ITEMS: Array[String] = ["chicken", "steak", "fish"]
const NON_FOOD_ITEMS: Array[String] = ["item_vase", "book", "plant"]

const ITEM_MIN_SPACING: float = 160.0
const MAX_PLACEMENT_TRIES: int = 12

var _cat: Node2D
var _active: bool = false


func _ready() -> void:
	_cat = get_node("../Cat")


func start() -> void:
	_active = true
	_schedule_next_spawn()


func stop() -> void:
	_active = false


func _schedule_next_spawn() -> void:
	if not _active:
		return
	var delay := randf_range(spawn_interval_min, spawn_interval_max)
	get_tree().create_timer(delay).timeout.connect(_spawn_item)


func _find_spawn_x() -> float:
	var occupied: Array[float] = []
	for live_item in get_tree().get_nodes_in_group("items"):
		if is_instance_valid(live_item) and not live_item._swiped:
			occupied.append(live_item.position.x)

	for _i in MAX_PLACEMENT_TRIES:
		var x := randf_range(spawn_x_min, spawn_x_max)
		var clear := true
		for ox in occupied:
			if abs(x - ox) < ITEM_MIN_SPACING:
				clear = false
				break
		if clear:
			return x

	return randf_range(spawn_x_min, spawn_x_max)


func _spawn_item() -> void:
	if not _active:
		return
	var item = ITEM_SCENE.instantiate()

	var is_food := randi() % 2 == 0
	if is_food:
		item.item_type = Item.ItemType.FOOD
		item.sprite_name = FOOD_ITEMS[randi() % FOOD_ITEMS.size()]
	else:
		item.item_type = Item.ItemType.NON_FOOD
		item.sprite_name = NON_FOOD_ITEMS[randi() % NON_FOOD_ITEMS.size()]

	item.position = Vector2(_find_spawn_x(), spawn_y)
	item.item_tapped.connect(_cat._on_item_tapped)
	item.item_hit_dog.connect(ScoreManager.on_item_hit_dog)

	get_parent().add_child(item)
	item.add_to_group("items")
	_schedule_next_spawn()
