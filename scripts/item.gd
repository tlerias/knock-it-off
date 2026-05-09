extends RigidBody2D

signal item_tapped(item)
signal item_hit_floor(item)
signal item_hit_dog(item)

enum ItemType { FOOD, NON_FOOD }

@export var item_lifetime: float = 4.0
@export var shake_threshold: float = 1.2

var item_type: ItemType = ItemType.NON_FOOD
var sprite_name: String = "item_vase"

@onready var sprite: Sprite2D = $Sprite2D

const SHAKE_AMOUNT: float = 6.0
const SHAKE_SPEED: float = 30.0

var _swiped: bool = false
var _lifetime_remaining: float = 0.0


func _ready() -> void:
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	input_pickable = true
	contact_monitor = true
	max_contacts_reported = 4
	sprite.texture = load("res://assets/sprites/items/" + sprite_name + ".png")
	body_entered.connect(_on_body_entered)
	_lifetime_remaining = item_lifetime


func _physics_process(delta: float) -> void:
	if _swiped:
		return
	_lifetime_remaining -= delta
	if _lifetime_remaining <= 0.0:
		queue_free()
		return
	if _lifetime_remaining < shake_threshold:
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
	sprite.position.x = 0.0
	linear_velocity = Vector2.ZERO
	item_tapped.emit(self)
	freeze = false
	angular_velocity = randf_range(4.0, 7.0) * (1.0 if randf() > 0.5 else -1.0)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("floor"):
		item_hit_floor.emit(self)
		queue_free()
