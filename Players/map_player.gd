extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	print(position)

	# Handle jump.
	if Input.is_action_just_pressed("accept"):
		print("accept clicked")

	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var direction2 := Input.get_axis("move_up", "move_down")
	if direction2:
		velocity.y = direction2 * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
