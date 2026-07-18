extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const GROUND_ACCEL = 10.0
const GROUND_FRICTION = 10.0
const AIR_ACCEL = 0.5
const AIR_FRICTION = 0.01
const SLIDE_GRAVITY = 500.0
const MASS = 1.5

	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * MASS

	var sliding := Input.is_action_pressed("slide")

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# walljump
	if Input.is_action_pressed("jump") and is_on_wall() and not is_on_floor():
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * SPEED
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if sliding:
		direction = 0

	if is_on_floor():
		if sliding:
			#wierd thingies which calculate vector of player sliding down
			var floor_normal = get_floor_normal()
			var downhill = -Vector2(floor_normal.y, -floor_normal.x)

			velocity += downhill * SLIDE_GRAVITY * delta
		else:
			velocity.x -= GROUND_FRICTION * velocity.x * delta
			velocity.x += GROUND_ACCEL * direction * SPEED * delta
	else:
		velocity.x -= AIR_FRICTION * velocity.x * delta
		velocity.x += AIR_ACCEL * direction * SPEED * delta

	move_and_slide()
