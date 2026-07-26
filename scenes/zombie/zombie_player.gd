extends CharacterBody2D

@export var speed: float = 400.0
@export var health: int = 100
@export var ShootingSound: AudioStreamPlayer
@export var ReloadSound: AudioStreamPlayer
@export var DamageTakenSound: AudioStreamPlayer


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoulders: Node2D = $Shoulders
@onready var hands_with_gun: Sprite2D = $Shoulders/HandsWithGun
@onready var muzzle: Node2D = $Shoulders/HandsWithGun/Muzzle
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var pistol_texture: Texture2D
@export var uzi_texture: Texture2D
@export var shotgun_texture: Texture2D
@export var machinegun_texture: Texture2D

var can_take_damage: bool = true
@export var invulnerability_time: float = 0.7

signal update_labels

var can_shoot: bool = true
var ammunition: Array[int] = []
var current_ammo: Array[int] = []
var is_reloading: bool = false

var bullet_scene: PackedScene = preload("res://scenes/zombie/Bullet.tscn")

func _ready() -> void:
	add_to_group("player")
	global.gun_changed.connect(_on_gun_changed)
	for i in range(global.weapons.size()):
		ammunition.append(global.weapons[i].zombie_ammo)
		current_ammo.append(global.weapons[i].zombie_ammo)
	update_labels.emit.call_deferred()

func _on_gun_changed():
	is_reloading = false
	ReloadSound.stop()
	update_ammo_label()
	match global.current_gun:
		0:
			hands_with_gun.texture = pistol_texture
		1:
			hands_with_gun.texture = uzi_texture
		2:
			hands_with_gun.texture = shotgun_texture
		3:
			hands_with_gun.texture = machinegun_texture

func update_ammo_label():
	update_labels.emit()

func play_animation(anim_name: String) -> void:
	match anim_name:
		"idle":
			animated_sprite.position = Vector2(-6, -53)
			animated_sprite.scale = Vector2(0.725, 0.725)
			shoulders.position = Vector2(-9 if not animated_sprite.flip_h else 0, -39)
		"run":
			animated_sprite.position = Vector2(-40 if not animated_sprite.flip_h else 20, -98)
			animated_sprite.scale = Vector2(1.035, 1.035)
			shoulders.position = Vector2(-3 if not animated_sprite.flip_h else -15, -26)
	animated_sprite.play(anim_name)

func update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		play_animation("run")
	else:
		play_animation("idle")
		
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	move_and_slide()
	
	update_animation(input_vector)

	var viewport_size: Vector2 = get_viewport_rect().size
	var padding: float = 3.0
	
	var rect_shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
	
	if rect_shape:
		var extents: Vector2 = (rect_shape.size / 2.0) * collision_shape.scale.abs() * scale.abs()
		
		var shape_offset: Vector2 = collision_shape.position * scale
		
		var min_x: float = padding + extents.x - shape_offset.x
		var max_x: float = viewport_size.x - padding - extents.x - shape_offset.x
		var min_y: float = padding + extents.y - shape_offset.y
		var max_y: float = viewport_size.y - padding - extents.y - shape_offset.y
		
		global_position.x = clamp(global_position.x, min_x, max_x)
		global_position.y = clamp(global_position.y, min_y, max_y)



func _process(_delta: float) -> void:
	rotate_hands()
	var current_weapon = global.weapons[global.current_gun]
	if current_weapon.is_auto and can_shoot and Input.is_action_pressed("click"):
		shoot()

func _unhandled_input(event: InputEvent) -> void:
	var current_weapon = global.weapons[global.current_gun]
	if not current_weapon.is_auto and event.is_action_pressed("click"):
		if can_shoot:
			shoot()
	if event.is_action_pressed("reload") and current_ammo[global.current_gun] < ammunition[global.current_gun]:
		reload()

#func _input(event: InputEvent) -> void:
#	pass

func shoot() -> void:
	if is_reloading:
		return
	can_shoot = false
	if current_ammo[global.current_gun] <= 0:
		reload()
		can_shoot = true
		return
	current_ammo[global.current_gun] -= 1
	update_ammo_label()
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

func rotate_hands() -> void:
	shoulders.look_at(get_global_mouse_position())
	var mouse_pos: Vector2 = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		hands_with_gun.flip_v = true
	else:
		hands_with_gun.flip_v = false

func reload() -> void:
	if is_reloading:
		return
	
	is_reloading = true
	update_ammo_label()
	ReloadSound.play()

	await get_tree().create_timer(global.weapons[global.current_gun].reload_time).timeout
	
	if is_reloading:
		current_ammo[global.current_gun] = ammunition[global.current_gun]
		is_reloading = false
		update_ammo_label()

func take_damage(amount: int) -> void:
	if not can_take_damage:
		return
	animated_sprite.modulate.a = 0.5
	can_take_damage = false
	health -= amount
	DamageTakenSound.play()
	if health <= 0:
		global.load_death_screen()
		queue_free()
	await get_tree().create_timer(invulnerability_time).timeout
	can_take_damage = true
	animated_sprite.modulate.a = 1.0
