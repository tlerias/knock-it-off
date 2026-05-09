extends Node2D

signal dog_caught_item(item)

enum State { WALKING, EATING, YELPING, OFFSCREEN }

const WALK_TEXTURE = preload("res://assets/sprites/dog/dog_walk_sheet.png")
const EAT_TEXTURE = preload("res://assets/sprites/dog/dog_eat.png")
const YELP_TEXTURE = preload("res://assets/sprites/dog/dog_yelp.png")
const Item = preload("res://scripts/item.gd")

@export var patrol_speed: float = 80.0
@export var run_speed: float = 300.0
@export var return_delay: float = 3.0
@export var eat_duration: float = 1.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_area: Area2D = $HitArea

const LEFT_BOUND: float = 60.0
const RIGHT_BOUND: float = 1860.0
const WALK_FRAMES: Array = [0, 1, 2, 3, 4, 3, 2, 1]
const FRAME_DURATION: float = 0.12
const WALK_FRAME_WIDTH: float = 250.0  # one frame's pixel width in the walk sheet
@export var dog_scale: float = 2.0

var _state: State = State.WALKING
var _direction: float = 1.0
var _frame_idx: int = 0
var _frame_timer: float = 0.0
var _action_timer: float = 0.0


func _ready() -> void:
	_set_walk_sprite()
	position.x = LEFT_BOUND
	hit_area.body_entered.connect(_on_item_hit)
	sprite.scale = Vector2(dog_scale, dog_scale)


func _process(delta: float) -> void:
	match _state:
		State.WALKING:
			_update_walk(delta)
		State.EATING:
			_action_timer -= delta
			if _action_timer <= 0.0:
				_set_walk_sprite()
				_state = State.WALKING
		State.YELPING:
			position.x += run_speed * delta
			if position.x > RIGHT_BOUND + 300.0:
				_state = State.OFFSCREEN
				_action_timer = return_delay
		State.OFFSCREEN:
			_action_timer -= delta
			if _action_timer <= 0.0:
				position.x = LEFT_BOUND - 200.0
				_direction = 1.0
				_set_walk_sprite()
				_state = State.WALKING


func _update_walk(delta: float) -> void:
	position.x += patrol_speed * _direction * delta
	sprite.flip_h = _direction > 0.0

	_frame_timer += delta
	if _frame_timer >= FRAME_DURATION:
		_frame_timer = 0.0
		_frame_idx = (_frame_idx + 1) % WALK_FRAMES.size()
		sprite.frame = WALK_FRAMES[_frame_idx]

	if position.x >= RIGHT_BOUND:
		_direction = -1.0
	elif position.x <= LEFT_BOUND:
		_direction = 1.0


func _on_item_hit(body: Node) -> void:
	if _state != State.WALKING:
		return
	if not (body is RigidBody2D and body._swiped):
		return
	body.item_hit_dog.emit(body)
	body.queue_free()
	if body.item_type == Item.ItemType.FOOD:
		_react_food()
	else:
		_react_non_food()


func _react_food() -> void:
	_state = State.EATING
	sprite.texture = EAT_TEXTURE
	sprite.hframes = 1
	sprite.vframes = 1
	sprite.frame = 0
	sprite.scale = Vector2.ONE * (WALK_FRAME_WIDTH * dog_scale / EAT_TEXTURE.get_width())
	_action_timer = eat_duration


func _react_non_food() -> void:
	_state = State.YELPING
	sprite.texture = YELP_TEXTURE
	sprite.hframes = 1
	sprite.vframes = 1
	sprite.frame = 0
	sprite.scale = Vector2.ONE * (WALK_FRAME_WIDTH * dog_scale / YELP_TEXTURE.get_width())
	_direction = 1.0
	sprite.flip_h = false


func _set_walk_sprite() -> void:
	sprite.texture = WALK_TEXTURE
	sprite.hframes = 2
	sprite.vframes = 3
	sprite.frame = WALK_FRAMES[_frame_idx]
	sprite.scale = Vector2(dog_scale, dog_scale)
