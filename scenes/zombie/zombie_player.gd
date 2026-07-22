extends CharacterBody2D

@export var speed: float = 400.0
@export var health: int = 100

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	move_and_slide()

	
	var viewport_size: Vector2 = get_viewport_rect().size
	var padding: float = 3.0
	
	var half_width: float = ($Sprite2D.texture.get_width() * scale.x) / 2.0
	var half_height: float = ($Sprite2D.texture.get_height() * scale.y) / 2.0
	
	global_position.x = clamp(global_position.x, padding + half_width, viewport_size.x - padding - half_width)
	global_position.y = clamp(global_position.y, padding + half_height, viewport_size.y - padding - half_height)
	print(viewport_size.y, " :   ", scale.y)

func take_damage(amount: int) -> void:
	health -= amount
	print("Player took ", amount, " damage!")
	print("Player health: ", health)
	if health <= 0:
		print("Player has died!")
		queue_free()
