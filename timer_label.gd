extends Label

func _ready():
	TimerGlobal.time_changed.connect(_on_time_changed)
	TimerGlobal.timer_start.connect(make_visible)


func _on_time_changed(seconds_left):
	var minutes = int(seconds_left) / 60
	var seconds = int(seconds_left) % 60

	text = "%02d:%02d" % [minutes, seconds]

func make_visible():
	visible = true
