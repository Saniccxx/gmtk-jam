extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -1000.0
const GROUND_ACCEL = 20.0
const GROUND_FRICTION = 10.0
const AIR_ACCEL = 5
const AIR_FRICTION = 0.5
const MASS = 3
const RECOIL_FORCE = 800.0
const AIR_ROTATION_SPEED = 10.0 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


var can_shoot = true

var jumping = false

func shoot() -> void:
	can_shoot = false
	await get_tree().create_timer(global.weapons[global.current_gun].fire_delay).timeout
	can_shoot = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * MASS

	var sliding := Input.is_action_pressed("slide")



	# recoil
	if global.weapons[global.current_gun].is_auto:
		if Input.is_action_pressed("click"):
			if can_shoot:
				var mouse_direction = (get_global_mouse_position() - global_position).normalized()
				velocity -= mouse_direction * global.weapons[global.current_gun].recoil[0]*40
				shoot()
	else:
		if Input.is_action_just_pressed("click"):
			if can_shoot:
				var mouse_direction = (get_global_mouse_position() - global_position).normalized()
				velocity -= mouse_direction * global.weapons[global.current_gun].recoil[0]*40
				shoot()
			

	var direction := Input.get_axis("move_left", "move_right")
	var floor_normal = get_floor_normal()
	if is_on_floor():
		if sliding:
			direction = 0
			# TODO fix player auto jumping at the end of the slope when he is high
			
			
			#wierd thingies which calculate vector of player sliding down

			var slope_tangent = Vector2(floor_normal.y, -floor_normal.x)
			
			print(slope_tangent)
			
			var downhill = slope_tangent * slope_tangent.dot(get_gravity())
			
			velocity += downhill * delta * MASS
			
		else:
			velocity.x -= GROUND_FRICTION * velocity.x * delta
			velocity.x += GROUND_ACCEL * direction * SPEED * delta
	else:
		velocity.x -= AIR_FRICTION * velocity.x * delta
		velocity.x += AIR_ACCEL * direction * SPEED * delta
		
	if is_on_floor():
		sprite.rotation = floor_normal.angle() + PI / 2
		jumping = false
	else:
		sprite.rotation = lerp_angle(sprite.rotation, 0.0, delta * AIR_ROTATION_SPEED)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true

	# walljump
	if Input.is_action_pressed("jump") and is_on_wall() and not is_on_floor():
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * SPEED * 2
		velocity.y = JUMP_VELOCITY - SPEED
		jumping = true
	
	if jumping:
		if sprite.animation != "jump":
			sprite.animation = "jump"
			sprite.play()
	elif sliding and is_on_floor():
		if sprite.animation != "slide":
			sprite.animation = "slide"
			sprite.play()
	elif abs(velocity.x) > 10:
		if direction == -1:
			sprite.flip_h = 1
		else:
			sprite.flip_h = 0
		if sprite.animation != "run_no_hands":
			sprite.animation = "run_no_hands"
			sprite.play()
	else:
		sprite.rotation = 0
		if sprite.animation != "default":
			sprite.animation = "default"
			sprite.play()

	print(jumping)

	move_and_slide()
