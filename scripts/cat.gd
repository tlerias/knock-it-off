extends Node2D

@export var cat_variant: int = 0  # 0 = Waffles, 1 = Prince
@export var swipe_duration: float = 0.4

@onready var sprite: Sprite2D = $Sprite2D

const IDLE_TEXTURES: Array = [
	preload("res://assets/sprites/cat/waffles-idle.png"),
	preload("res://assets/sprites/cat/prince-idle.png"),
]
const SWIPE_TEXTURES: Array = [
	preload("res://assets/sprites/cat/waffles-swipe.png"),
	preload("res://assets/sprites/cat/prince-swipe.png"),
]

var _swipe_timer: float = 0.0


func _ready() -> void:
	_set_idle()


func _process(delta: float) -> void:
	if _swipe_timer > 0.0:
		_swipe_timer -= delta
		if _swipe_timer <= 0.0:
			_set_idle()


func _on_item_tapped(item: Node) -> void:
	position.x = item.position.x
	_set_swipe()
	_swipe_timer = swipe_duration


func _set_idle() -> void:
	sprite.texture = IDLE_TEXTURES[cat_variant]


func _set_swipe() -> void:
	sprite.texture = SWIPE_TEXTURES[cat_variant]
