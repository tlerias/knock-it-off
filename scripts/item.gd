extends RigidBody2D

signal item_tapped(item)
signal item_hit_floor(item)

enum ItemType { FOOD, NON_FOOD }

@export var slide_speed: float = 120.0

var item_type: ItemType = ItemType.NON_FOOD
var sprite_name: String = "item_vase"

@onready var sprite: Sprite2D = $Sprite2D

const LEFT_EDGE_X: float = -100.0
const SHAKE_THRESHOLD: float = 220.0
const SHAKE_AMOUNT: float = 6.0
const SHAKE_SPEED: float = 30.0

var _swiped: bool = false


func _ready() -> void:
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	input_pickable = true
	contact_monitor = true
	max_contacts_reported = 4
	sprite.texture = load("res://assets/sprites/items/" + sprite_name + ".png")
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _swiped:
		return
	position.x -= slide_speed * delta
	if position.x < LEFT_EDGE_X:
		queue_free()
	if position.x < SHAKE_THRESHOLD:
		sprite.position.x = sin(Time.get_ticks_msec() * 0.001 * SHAKE_SPEED) * SHAKE_AMOUNT
	else:
		sprite.position.x = 0.0


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if _swiped:
		return
	if event is InputEventScreenTouch and event.pressed:
		_on_tapped()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_tapped()


func _on_tapped() -> void:
	_swiped = true
	linear_velocity = Vector2.ZERO
	item_tapped.emit(self)
	freeze = false
	angular_velocity = randf_range(4.0, 7.0) * (1.0 if randf() > 0.5 else -1.0)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("floor"):
		item_hit_floor.emit(self)
		queue_free()
