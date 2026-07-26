extends Area2D
signal damage()
signal update_labels()
signal hitmark(position)
const SPEED = 400.0
var can_shoot:bool = true
var aimed_targets = []
var due_recoil: float = 0
var recoil_catchup_speed = 0.5
var i_frames: float = 1
var can_hurt = true
var recoil_values = []
var max_ammo: Array[int] = []
var current_ammo: Array[int] = []
var is_reloading: bool = false
var damage_mults: Array[int]= [1, 2, 3, 16]

@export var ShootingSound: AudioStreamPlayer
@export var ReloadSound: AudioStreamPlayer

func _ready() -> void:
	global.gun_changed.connect(_on_gun_changed)
	for i in range(len(global.weapons)):
		recoil_values.append(global.weapons[i].recoil[1])
		max_ammo.append(global.weapons[i].ammo)
		current_ammo.append(global.weapons[i].ammo)
		
func _on_gun_changed():
	is_reloading = false
	ReloadSound.stop()
	update_labels.emit()
	

func shoot():
	if is_reloading:
		return
	if current_ammo[global.current_gun] <= 0:
		reload()
		can_shoot = true
		return
	current_ammo[global.current_gun] -= 1
	update_labels.emit()
	hitmark.emit(position)
	due_recoil += recoil_values[global.current_gun]
	var suma = 0
	ShootingSound.play()

	if len(aimed_targets) == 0:
		if can_hurt:
			print("life lost")
			damage.emit()
			hurt_timer()
		if global.current_gun == 2:
			shotgun_shoot(1, false)
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
	suma *= damage_mults[global.current_gun]
	global.money += suma
	return
	
func reload():
	if is_reloading:
		return
	
	is_reloading = true
	update_labels.emit()
	ReloadSound.play()
	await get_tree().create_timer(global.weapons[0].reload_time).timeout
	
	if is_reloading:
		current_ammo[global.current_gun] = max_ammo[global.current_gun]
		is_reloading = false
		update_labels.emit()

func shoot_timer():
	if get_tree() == null:
		return
	can_shoot = false
	var amount = global.weapons[global.current_gun].fire_delay
	await get_tree().create_timer(amount).timeout
	can_shoot = true

func hurt_timer():
	if get_tree() == null:
		return
	can_hurt = false
	await get_tree().create_timer(i_frames).timeout
	can_hurt = true

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var velocity = input_vector * SPEED
	if Input.is_action_pressed("right_click"):
		velocity *= 2
	if Input.is_action_just_pressed("reload") and current_ammo[global.current_gun] < max_ammo[global.current_gun]:
		reload()
	position += velocity * delta
	position[1] -= due_recoil * recoil_catchup_speed
	due_recoil -= due_recoil * recoil_catchup_speed
	if position[0] < 10:
		position[0] = 10
	if position[1] < 10:
		position[1] = 10
	if position[0] > 1910:
		position[0] = 1910
	if position[1] > 1070:
		position[1] = 1070
	
	
		
func _process(delta: float) -> void:
	if not can_shoot: return
	if global.weapons[global.current_gun].is_auto:
		if Input.is_action_pressed("click"):
			shoot()
			shoot_timer()
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

func shotgun_shoot(target, hit=true):
	var suma = 0
	for bullet in range(global.weapons[2].bullets_per_shot):
		var bullet_pos = global_position + get_shotgun_spread(25)
		hitmark.emit(bullet_pos)
		if not hit:
			continue
		var distance = bullet_pos.distance_to(target.global_position)
		if distance < 30:
			suma += 3
		elif distance < 55:
			suma += 2
		else: suma += 1
	return suma * damage_mults[2]
func _on_area_entered(area: Area2D) -> void:
	aimed_targets.append(area)

func _on_area_exited(area: Area2D) -> void:
	aimed_targets.erase(area)
