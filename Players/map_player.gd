extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		print("accept")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if Input.is_action_just_pressed("ui_move_left"):
		#velocity.x = SPEED * delta
	#elif Input.is_action_just_pressed("ui_move_right"):
		#velocity.x = -SPEED * delta
		
	var direction := Input.get_axis("move_left", "move_right")
	var direction_2 := Input.get_axis("move_up", "move_down")
	if direction:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	if direction_2:
		velocity.y = SPEED * direction_2
	else:
		velocity.y = 0

	move_and_slide()
