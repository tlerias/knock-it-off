extends Node2D

enum State { WALKING, EATING, YELPING, OFFSCREEN }

const WALK_TEXTURE = preload("res://assets/sprites/dog/dog_walk_sheet.png")
const EAT_TEXTURE = preload("res://assets/sprites/dog/dog_eat.png")
const YELP_TEXTURE = preload("res://assets/sprites/dog/dog_yelp.png")
const Item = preload("res://scripts/item.gd")

@export var patrol_speed: float = 80.0
@export var run_speed: float = 300.0
@export var return_delay: float = 3.0
@export var eat_duration: float = 1.5
@export var dog_scale: float = 2.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_area: Area2D = $HitArea

const LEFT_BOUND: float = 60.0
const RIGHT_BOUND: float = 1860.0
const WALK_FRAME_WIDTH: float = 250.0

var _state: State = State.WALKING
var _direction: float = 1.0
var _action_timer: float = 0.0


func _ready() -> void:
	_setup_animations()
	sprite.scale = Vector2(dog_scale, dog_scale)
	position.x = LEFT_BOUND
	hit_area.body_entered.connect(_on_item_hit)
	sprite.play("walk")


func _setup_animations() -> void:
	var frames := SpriteFrames.new()
	var frame_w := 250
	var frame_h := WALK_TEXTURE.get_height() / 3

	frames.add_animation("walk")
	frames.set_animation_loop("walk", true)
	frames.set_animation_speed("walk", 8.0)
	for i in range(5):
		var atlas := AtlasTexture.new()
		atlas.atlas = WALK_TEXTURE
		atlas.region = Rect2((i % 2) * frame_w, (i / 2) * frame_h, frame_w, frame_h)
		frames.add_frame("walk", atlas)

	frames.add_animation("eat")
	frames.set_animation_loop("eat", false)
	frames.set_animation_speed("eat", 1.0)
	frames.add_frame("eat", EAT_TEXTURE)

	frames.add_animation("yelp")
	frames.set_animation_loop("yelp", false)
	frames.set_animation_speed("yelp", 1.0)
	frames.add_frame("yelp", YELP_TEXTURE)

	sprite.sprite_frames = frames


func _process(delta: float) -> void:
	match _state:
		State.WALKING:
			_update_walk(delta)
		State.EATING:
			_action_timer -= delta
			if _action_timer <= 0.0:
				_resume_walking()
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
				_resume_walking()


func _update_walk(delta: float) -> void:
	position.x += patrol_speed * _direction * delta
	sprite.flip_h = _direction > 0.0
	if position.x >= RIGHT_BOUND:
		_direction = -1.0
	elif position.x <= LEFT_BOUND:
		_direction = 1.0


func _resume_walking() -> void:
	sprite.scale = Vector2(dog_scale, dog_scale)
	sprite.play("walk")
	_state = State.WALKING


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
	sprite.scale = Vector2.ONE * (WALK_FRAME_WIDTH * dog_scale / EAT_TEXTURE.get_width())
	sprite.play("eat")
	_action_timer = eat_duration


func _react_non_food() -> void:
	_state = State.YELPING
	sprite.scale = Vector2.ONE * (WALK_FRAME_WIDTH * dog_scale / YELP_TEXTURE.get_width())
	sprite.play("yelp")
	_direction = 1.0
	sprite.flip_h = false
