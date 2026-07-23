extends CharacterBody2D

@export var speed: float = 400.0
@export var health: int = 100
var can_shoot: bool = true

var bullet_scene: PackedScene = preload("res://scenes/zombie/Bullet.tscn")

func _ready() -> void:
	add_to_group("player")
	global.best_owned_gun = 3

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	move_and_slide()
	
	if input_vector.x < 0:
		$Sprite2D.flip_h = true
	elif input_vector.x > 0:
		$Sprite2D.flip_h = false
	
	var viewport_size: Vector2 = get_viewport_rect().size
	var padding: float = 3.0
	
	var half_width: float = ($Sprite2D.texture.get_width() * $Sprite2D.scale.x) / 2.0
	var half_height: float = ($Sprite2D.texture.get_height() * $Sprite2D.scale.y) / 2.0
	
	global_position.x = clamp(global_position.x, padding + half_width, viewport_size.x - padding - half_width)
	global_position.y = clamp(global_position.y, padding + half_height, viewport_size.y - padding - half_height)
	
func _process(delta: float) -> void:
	if global.weapons[global.current_gun].is_auto and can_shoot:
		if Input.is_action_pressed("click"):
			shoot()
	else:
		if Input.is_action_just_pressed("click") and can_shoot:
			shoot()
	#global.weapons.append(global.Weapon.new("pistol", 0, "res://assets/pistol.png", false))

func _input(event: InputEvent) -> void:
	pass

func shoot() -> void:
	can_shoot = false

#	var bullet: Node2D = bullet_scene.instantiate()
#	bullet.global_position = global_position
#	bullet.look_at(get_global_mouse_position())
#	get_parent().add_child(bullet)
	for i in range(global.weapons[global.current_gun].bullets_per_shot):
		spawn_bullet()
	
	await get_tree().create_timer(global.weapons[global.current_gun].fire_delay).timeout
	can_shoot = true

func spawn_bullet() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	
	var base_rotation: float = global_position.angle_to_point(get_global_mouse_position())

	var random_spread: float = randf_range(-global.weapons[global.current_gun].spread_angle / 2.0, global.weapons[global.current_gun].spread_angle / 2.0)
	var final_rotation: float = base_rotation + deg_to_rad(random_spread)

	bullet.global_position = global_position
	bullet.rotation = final_rotation
	
	get_parent().add_child(bullet)
func take_damage(amount: int) -> void:
	health -= amount
	print("Player took ", amount, " damage!")
	print("Player health: ", health)
	if health <= 0:
		global.load_death_screen()
		queue_free()
