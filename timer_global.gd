extends Node

var time_left := 601.0
var running := false

signal time_changed(seconds_left)
signal timer_start()
signal timer_finished

func start():
	timer_start.emit()
	running = true

func stop():
	running = false

func reset():
	time_left = 601.0
	time_changed.emit(time_left)

func _process(delta):
	if !running:
		return

	time_left -= delta

	time_changed.emit(time_left)

	if time_left <= 0:
		time_left = 0
		running = false
		time_changed.emit(0)
		timer_finished.emit()
