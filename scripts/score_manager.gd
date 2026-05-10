extends Node

const Item = preload("res://scripts/item.gd")

signal score_changed(score: int)
signal score_applied(amount: int, world_pos: Vector2)
signal first_nonfood_dog_hit

const FOOD_DOG_SCORE: int = 25
const FOOD_FLOOR_SCORE: int = 1
const NONFOOD_DOG_PENALTY: int = -15

var score: int = 0
var _nonfood_hint_shown: bool = false


func reset() -> void:
	score = 0
	_nonfood_hint_shown = false
	score_changed.emit(score)


func on_item_hit_dog(item: Node) -> void:
	var amount: int
	if item.item_type == Item.ItemType.FOOD:
		amount = FOOD_DOG_SCORE
	else:
		if not _nonfood_hint_shown:
			_nonfood_hint_shown = true
			first_nonfood_dog_hit.emit()
		amount = NONFOOD_DOG_PENALTY
	score_applied.emit(amount, item.global_position)
	add_score(amount)


func on_floor_food_picked_up(item: Node) -> void:
	score_applied.emit(FOOD_FLOOR_SCORE, item.global_position)
	add_score(FOOD_FLOOR_SCORE)


func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
