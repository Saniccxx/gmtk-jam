extends Area2D
@onready var phase = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if phase == 0:
		if scale[0] >= 10:
			phase = 1
			$Timer.start()
		else:
			scale[0] += 1
			scale[1] += 1
	if phase == 2:
		if scale[0] <= 0:
			queue_free()
		else:
			scale[0] -= 1
			scale[1] -= 1


func _on_timer_timeout() -> void:
	phase = 2
