extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	rotation = randf()*365


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = $Timer.time_left / 0.5


func _on_timer_timeout() -> void:
	queue_free()
