extends Area2D
@onready var phase = 0
@export var speed:int
@onready var destination: Vector2
const lifespan = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination = get_random_coords()



func _process(delta: float) -> void:
	if phase == 0:
		if scale[0] >= 10:
			phase = 1
			if speed == 0:
				$Timer.wait_time = lifespan - 2
			$Timer.start()
		else:
			scale[0] += 1
			scale[1] += 1
	elif phase == 1:
		move(delta)
	if phase == 2:
		if scale[0] <= 0:
			queue_free()
		else:
			scale[0] -= 0.5
			scale[1] -= 0.5


func _on_timer_timeout() -> void:
	phase = 2

func get_random_coords() -> Vector2:
	var border = 100 # distance from screen edges
	var screen_size = get_viewport_rect().size
	
	return Vector2(
		randf_range(border, screen_size.x - border),
		randf_range(border, screen_size.y - border)
	)

func move(delta):
	var direction = global_position.direction_to(destination)
	global_position += direction * speed * delta
	if global_position.distance_to(destination) < speed:
		destination = get_random_coords()
