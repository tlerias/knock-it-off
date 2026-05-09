extends Node

signal time_up
signal tick(remaining: float)

@export var duration: float = 60.0

var time_remaining: float = 0.0
var _running: bool = false


func start() -> void:
	time_remaining = duration
	_running = true


func _process(delta: float) -> void:
	if not _running:
		return
	time_remaining -= delta
	if time_remaining <= 0.0:
		time_remaining = 0.0
		_running = false
		tick.emit(0.0)
		time_up.emit()
	else:
		tick.emit(time_remaining)
