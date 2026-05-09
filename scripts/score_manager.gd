extends Node

signal score_changed(score: int)

const FOOD_DOG_SCORE: int = 25
const NONFOOD_DOG_PENALTY: int = -15

var score: int = 0


func reset() -> void:
	score = 0
	score_changed.emit(score)


func on_item_hit_dog(item: Node) -> void:
	if item.item_type == 0:  # ItemType.FOOD
		add_score(FOOD_DOG_SCORE)
	else:
		add_score(NONFOOD_DOG_PENALTY)


func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
