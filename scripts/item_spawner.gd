extends Node

@export var spawn_interval_min: float = 1.0
@export var spawn_interval_max: float = 2.0
@export var spawn_x_min: float = 300.0
@export var spawn_x_max: float = 1700.0
@export var spawn_y: float = 406.0

const ITEM_SCENE = preload("res://scenes/item.tscn")
const Item = preload("res://scripts/item.gd")

const FOOD_ITEMS: Array[String] = ["chicken", "steak", "fish"]
const NON_FOOD_ITEMS: Array[String] = ["item_vase", "book", "plant"]

var _cat: Node2D


func _ready() -> void:
	_cat = get_node("../Cat")
	_schedule_next_spawn()


func _schedule_next_spawn() -> void:
	var delay := randf_range(spawn_interval_min, spawn_interval_max)
	get_tree().create_timer(delay).timeout.connect(_spawn_item)


func _spawn_item() -> void:
	var item = ITEM_SCENE.instantiate()

	var is_food := randi() % 2 == 0
	if is_food:
		item.item_type = Item.ItemType.FOOD
		item.sprite_name = FOOD_ITEMS[randi() % FOOD_ITEMS.size()]
	else:
		item.item_type = Item.ItemType.NON_FOOD
		item.sprite_name = NON_FOOD_ITEMS[randi() % NON_FOOD_ITEMS.size()]

	item.position = Vector2(randf_range(spawn_x_min, spawn_x_max), spawn_y)
	item.item_tapped.connect(_cat._on_item_tapped)

	get_parent().add_child(item)
	_schedule_next_spawn()
