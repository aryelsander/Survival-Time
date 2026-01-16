class_name GlobalTimer extends Node

signal started
signal stopped
signal timeout
signal completed
@export var wait_time : float
@export var autoplay: bool
var _current_time : float

var _is_complete : bool
var _is_stop : bool
var _is_time : bool:
	get:
		return _current_time == wait_time
var time_elapsed : float:
	get:
		return _current_time
var time_left : float:
	get:
		return wait_time - _current_time

func _ready() -> void:
	_is_stop = not autoplay
	if autoplay:
		start()
		
func _process(delta: float) -> void:
	if _is_stop : return
	
	_current_time = clamp(_current_time + delta * GameManager.global_time_speed,0,wait_time)
	if _is_time and autoplay:
		_on_completed()
		_on_timeout()
	elif _is_time and not _is_complete and not autoplay:
		_on_completed()

func start():
	_is_stop = false
	started.emit()

func reload():
	_current_time = 0
	_is_complete = false

func _on_completed():
	_is_complete = true
	completed.emit()
func finish():
	_on_timeout()
func _on_timeout() -> void:
	timeout.emit()
	_current_time = 0
	_is_complete = false
	
func stop() -> void:
	if _is_stop: return
	_is_stop = true
	stopped.emit()
