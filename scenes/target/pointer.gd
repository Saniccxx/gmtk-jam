extends Area2D
const SPEED = 400.0

var aimed_targets = []


func shoot():
	var suma = 0
	for target in aimed_targets:
		var distance = global_position.distance_to(target.global_position)
		if distance < 30:
			suma += 3
		elif distance < 55:
			suma += 2
		else: suma += 1
	return suma
	

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = input_vector * SPEED
	position += velocity * delta
	
	if Input.is_action_just_pressed("click"):
		global.money += shoot()



func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	aimed_targets.append(area)

func _on_area_exited(area: Area2D) -> void:
	aimed_targets.erase(area)
