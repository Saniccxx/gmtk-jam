extends Area2D
const SPEED = 400.0
var can_shoot:bool = true
var aimed_targets = []


func shoot():
	var suma = 0
	if len(aimed_targets) == 0:
		print("life lost")
		return
	
	for target in aimed_targets:
		if global.current_gun == 2:
			global.money += shotgun_shoot(target)
			return
		var distance = global_position.distance_to(target.global_position)
		if distance < 30:
			suma += 3
		elif distance < 55:
			suma += 2
		else: suma += 1
	global.money += suma
	return
	
func shoot_timer():
	can_shoot = false
	await get_tree().create_timer(global.weapons[global.current_gun].fire_delay).timeout
	can_shoot = true

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = input_vector * SPEED
	position += velocity * delta
	if not can_shoot: return
	if global.weapons[global.current_gun].is_auto:
		if Input.is_action_pressed("click"):
			shoot()
	else:
		if Input.is_action_just_pressed("click"):
			shoot()
	shoot_timer()
		

func get_shotgun_spread(radius: float) -> Vector2:
	var angle = randf_range(0, TAU)
	var distance = sqrt(randf()) * radius
	
	return Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	)

func shotgun_shoot(target):
	var suma = 0
	for bullet in range(global.weapons[2].bullets_per_shot):
		var bullet_pos = global_position + get_shotgun_spread(16)
		var distance = bullet_pos.distance_to(target.global_position)
		if distance < 30:
			suma += 3
		elif distance < 55:
			suma += 2
		else: suma += 1
	print(suma)
	return suma
func _on_area_entered(area: Area2D) -> void:
	aimed_targets.append(area)

func _on_area_exited(area: Area2D) -> void:
	aimed_targets.erase(area)
