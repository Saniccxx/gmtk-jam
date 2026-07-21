extends CharacterBody2D

@export var speed: float = 400.0
@export var health: int = 100

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	var direction2 := Input.get_axis("move_up", "move_down")
	if direction2:
		velocity.y = direction2 * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	print("Player took ", amount, " damage!")
	print("Player health: ", health)
	if health <= 0:
		print("Player has died!")
		queue_free()
