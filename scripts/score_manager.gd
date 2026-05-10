extends Node

signal score_changed(score: int)
signal first_nonfood_dog_hit

const FOOD_DOG_SCORE: int = 25
const NONFOOD_DOG_PENALTY: int = -15

var score: int = 0
var _nonfood_hint_shown: bool = false


func reset() -> void:
	score = 0
	_nonfood_hint_shown = false
	score_changed.emit(score)


func on_item_hit_dog(item: Node) -> void:
	if item.item_type == 0:  # ItemType.FOOD
		add_score(FOOD_DOG_SCORE)
	else:
		if not _nonfood_hint_shown:
			_nonfood_hint_shown = true
			first_nonfood_dog_hit.emit()
		add_score(NONFOOD_DOG_PENALTY)


func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
