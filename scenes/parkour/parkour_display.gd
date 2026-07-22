extends Node2D

@onready var player = $Player
@onready var obstacles = $Obstacles
@onready var lava = $Player/Camera2D/Lava

var platform_texture = preload("res://scenes/parkour/assets/platform.png")

var base_texture_size = Vector2(300.0, 50.0)
var platform_scale = Vector2(1.0, 1.0) 
var platform_scale_variance = 0.5

var current_gen_x = -1000.0
var current_gen_y = 0.0
var platform_spacing_x = 400.0
var vertical_range = 200.0 
var rotate_range = PI/6
var threshold_range = 10000.0

@export var camera_y_follow_speed: float = 4.0
@export var lava_floor_y: float = 700.0

var ramp_chance: float = 0.2
var ramp_angle: float = PI / 5.0
var ramp_scale: Vector2 = Vector2(5.0, 1.2)
var ramp_gap_distance: float = 1200.0

const WIN_DISTANCE = 100000.0

func _ready() -> void:
	# ground
	spawn_platform(Vector2(0, 200), 0.0, Vector2(3.0, 1.0))
	current_gen_y = 200.0
	
	generate_platforms(threshold_range)

func _process(delta: float) -> void:
	
	var target_y = player.global_position.y
	
	lava.global_position.y = lava_floor_y
	
	var gen_threshold = player.global_position.x + threshold_range
	if current_gen_x < gen_threshold:
		generate_platforms(gen_threshold)
		
	cleanup_platforms()
	
	if player.global_position.x >= WIN_DISTANCE:
		global.load_winner_screen()


func generate_platforms(target_x: float) -> void:
	while current_gen_x < target_x:
		if randf() < ramp_chance:
			spawn_ramp_sequence()
		else:
			spawn_standard_platform()


func spawn_standard_platform() -> void:
	var y_drift = randf_range(-80.0, 80.0)
	current_gen_y = clamp(current_gen_y + y_drift, -vertical_range, vertical_range)
	
	var random_rot = randf_range(-rotate_range, rotate_range) 
	var random_scale1 = randf_range(platform_scale[0]-platform_scale_variance, platform_scale[0]+platform_scale_variance)
	var random_scale2 = randf_range(platform_scale[1]-platform_scale_variance, platform_scale[1]+platform_scale_variance)
			
	spawn_platform(Vector2(current_gen_x, current_gen_y), random_rot, Vector2(random_scale1, random_scale2))
	
	current_gen_x += platform_spacing_x


func spawn_ramp_sequence() -> void:
	# platforms go up
	var target_ramp_y = -350.0
	var lead_up_count = randi_range(3, 5)
	var start_y = current_gen_y
	
	for i in range(lead_up_count):
		var progress = float(i + 1) / float(lead_up_count)
		var target_step_y = lerp(start_y, target_ramp_y, progress)
		var random_noise = randf_range(-40.0, 40.0)
		current_gen_y = target_step_y + random_noise
		
		var lead_rot = randf_range(-PI / 12.0, PI / 12.0)
		spawn_platform(Vector2(current_gen_x, current_gen_y), lead_rot, platform_scale)
		current_gen_x += platform_spacing_x

	# ramp
	spawn_platform(Vector2(current_gen_x, current_gen_y), ramp_angle, ramp_scale)
	
	var ramp_width = base_texture_size.x * ramp_scale.x
	var ramp_length_x = ramp_width * cos(ramp_angle)
	var ramp_drop_y = ramp_width * sin(ramp_angle)
	
	# Gap und landing thingies
	current_gen_x += ramp_length_x + ramp_gap_distance
	current_gen_y = current_gen_y + ramp_drop_y + 100.0
	spawn_platform(Vector2(current_gen_x, current_gen_y), 0.0, Vector2(2.5, 1.0))
	
	current_gen_x += platform_spacing_x


func spawn_platform(pos: Vector2, rot: float, scale_multiplier: Vector2) -> void:
	var platform = StaticBody2D.new()
	platform.position = pos
	platform.rotation = rot
	
	var sprite = Sprite2D.new()
	sprite.texture = platform_texture
	sprite.scale = scale_multiplier
	platform.add_child(sprite)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = base_texture_size * scale_multiplier
	collision.shape = shape
	platform.add_child(collision)
	
	obstacles.add_child(platform)

func cleanup_platforms() -> void:
	for child in obstacles.get_children():
		if child.global_position.x < player.global_position.x - threshold_range:
			child.queue_free()


func _on_lava_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		global.load_death_screen()
