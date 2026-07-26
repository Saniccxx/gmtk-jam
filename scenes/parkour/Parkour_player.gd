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

@export var ShootingSound: AudioStreamPlayer
@export var ReloadSound: AudioStreamPlayer

signal update_labels

enum SlideState { NONE, INTRO, LOOP, OUTRO }
var slide_state := SlideState.NONE
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoulders: Node2D = $Shoulders
@onready var hands_with_gun: Sprite2D = $Shoulders/HandsWithGun
@onready var muzzle: Node2D = $Shoulders/HandsWithGun/Muzzle

var can_shoot: bool = true
var ammunition: Array[int] = []
var current_ammo: Array[int] = []
var is_reloading: bool = false
var bullet_scene: PackedScene = preload("res://scenes/zombie/Bullet.tscn")
var jumping = false

func _ready() -> void:
	add_to_group("player")
	global.gun_changed.connect(_on_gun_changed)
	for i in range(global.weapons.size()):
		ammunition.append(global.weapons[i].zombie_ammo)
		current_ammo.append(global.weapons[i].zombie_ammo)

func _on_gun_changed() -> void:
	is_reloading = false
	ReloadSound.stop()

func rotate_hands() -> void:
	shoulders.look_at(get_global_mouse_position())
	var mouse_pos: Vector2 = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		hands_with_gun.flip_v = true
	else:
		hands_with_gun.flip_v = false

func _process(_delta: float) -> void:
	rotate_hands()

func shoot() -> void:
	if is_reloading:
		return
	can_shoot = false
	if current_ammo[global.current_gun] <= 0:
		reload()
		can_shoot = true
		return
	current_ammo[global.current_gun] -= 1

	ShootingSound.play()

	for i in range(global.weapons[global.current_gun].bullets_per_shot):
		spawn_bullet()

	await get_tree().create_timer(global.weapons[global.current_gun].fire_delay).timeout
	can_shoot = true

func spawn_bullet() -> void:
	var bullet: Node2D = bullet_scene.instantiate()
	var muzzle_pos: Vector2 = muzzle.global_position

	var base_rotation: float = muzzle_pos.angle_to_point(get_global_mouse_position())
	var random_spread: float = randf_range(-global.weapons[global.current_gun].spread_angle / 2.0, global.weapons[global.current_gun].spread_angle / 2.0)
	var final_rotation: float = base_rotation + deg_to_rad(random_spread)

	bullet.global_position = muzzle_pos
	bullet.rotation = final_rotation

	get_parent().add_child(bullet)

func reload() -> void:
	if is_reloading:
		return

	is_reloading = true
	ReloadSound.play()
	await get_tree().create_timer(global.weapons[global.current_gun].reload_time).timeout

	if is_reloading:
		current_ammo[global.current_gun] = ammunition[global.current_gun]
		is_reloading = false

func _on_sprite_animation_finished() -> void:
	if slide_state == SlideState.INTRO:
		slide_state = SlideState.LOOP
		sprite.play("slide_loop")
	elif slide_state == SlideState.OUTRO:
		slide_state = SlideState.NONE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reload") and current_ammo[global.current_gun] < ammunition[global.current_gun]:
		reload()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * MASS
	var sliding := Input.is_action_pressed("slide") and is_on_floor()
	if sliding:
		if slide_state == SlideState.NONE:
			slide_state = SlideState.INTRO
			sprite.animation = "slide_intro"
			sprite.play()
	else:
		if slide_state == SlideState.INTRO or slide_state == SlideState.LOOP:
			slide_state = SlideState.OUTRO
			sprite.animation = "slide_outro"
			sprite.play()

	# recoil + shooting
	if global.weapons[global.current_gun].is_auto:
		if Input.is_action_pressed("click"):
			if can_shoot and not is_reloading:
				var mouse_direction = (get_global_mouse_position() - global_position).normalized()
				velocity -= mouse_direction * global.weapons[global.current_gun].recoil[0] * 40
				shoot()
	else:
		if Input.is_action_just_pressed("click"):
			if can_shoot and not is_reloading:
				var mouse_direction = (get_global_mouse_position() - global_position).normalized()
				velocity -= mouse_direction * global.weapons[global.current_gun].recoil[0] * 40
				shoot()

	var direction := Input.get_axis("move_left", "move_right")

	var floor_normal = get_floor_normal()
	if is_on_floor():
		if sliding:
			direction = 0
			var slope_tangent = Vector2(floor_normal.y, -floor_normal.x)
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
		slide_state = SlideState.NONE

	if Input.is_action_pressed("jump") and is_on_wall() and not is_on_floor():
		var wall_normal = get_wall_normal()
		velocity.x = wall_normal.x * SPEED * 2
		velocity.y = JUMP_VELOCITY - SPEED
		jumping = true
		slide_state = SlideState.NONE

	# --- HIDE/SHOW SHOULDERS WHEN JUMPING OR SLIDING ---
	var is_sliding := slide_state != SlideState.NONE
	shoulders.visible = not (jumping or is_sliding)

	# --- ANIMATION & TRANSFORM UPDATES (MATCHING ZOMBIE PLAYER) ---
	if jumping:
		if sprite.animation != "jump":
			sprite.animation = "jump"
			sprite.play()
	elif slide_state != SlideState.NONE:
		pass
	elif abs(velocity.x) > 10:
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false

		sprite.position = Vector2(-40 if not sprite.flip_h else 20, -98)
		sprite.scale = Vector2(1.035, 1.035)
		shoulders.position = Vector2(-3 if not sprite.flip_h else -15, -26)

		if sprite.animation != "run_no_hands":
			sprite.animation = "run_no_hands"
			sprite.play()
	else:
		sprite.rotation = 0
		sprite.position = Vector2(-6, -53)
		sprite.scale = Vector2(0.725, 0.725)
		shoulders.position = Vector2(-9 if not sprite.flip_h else 0, -39)

		if sprite.animation != "default":
			sprite.animation = "default"
			sprite.play()

	move_and_slide()
