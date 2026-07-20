extends Node2D

@onready var player = $Player
@onready var camera = $Camera2D
@onready var obstacles = $Obstacles

var platform_texture = preload("res://scenes/parkour/assets/platform.png")

var base_texture_size = Vector2(300.0, 50.0)
var platform_scale = Vector2(3.0, 3.0) 
var platform_scale_variance = 2.0

var current_gen_x = -1000.0
var platform_spacing_x = 1400.0
var vertical_range = 1000.0 
var rotate_range = PI/6
var threshold_range = 10000.0


const WIN_DISTANCE = 100000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# ground
	spawn_platform(Vector2(0, 500), 0.0, Vector2(6.0, 3.0))
	
	generate_platforms(threshold_range)

func _process(_delta: float) -> void:
	if player.global_position.x > camera.global_position.x:
		camera.global_position.x = player.global_position.x
	
	var gen_threshold = camera.global_position.x + threshold_range
	if current_gen_x < gen_threshold:
		generate_platforms(gen_threshold)
		
	cleanup_platforms()
	
	if player.global_position.x >= WIN_DISTANCE:
		get_tree().change_scene_to_file.call_deferred("res://scenes/parkour/winner_display.tscn")


func generate_platforms(target_x: float) -> void:
	while current_gen_x < target_x:
		var random_y = randf_range(-vertical_range, vertical_range)
		
		var random_rot = randf_range(-rotate_range, rotate_range) 
			
		spawn_platform(Vector2(current_gen_x, random_y), random_rot, Vector2(randf_range(platform_scale[0]-platform_scale_variance, platform_scale[0]+platform_scale_variance), randf_range(platform_scale[1]-platform_scale_variance, platform_scale[1]+platform_scale_variance)))
		
		current_gen_x += platform_spacing_x

func spawn_platform(pos: Vector2, rot: float, scale_multiplier: Vector2) -> void:
	var platform = StaticBody2D.new()
	platform.position = pos
	platform.rotation = rot
	
	# scaled visual sprite
	var sprite = Sprite2D.new()
	sprite.texture = platform_texture
	sprite.scale = scale_multiplier
	platform.add_child(sprite)
	
	# scaled collision box matching the image size
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = base_texture_size * scale_multiplier
	collision.shape = shape
	platform.add_child(collision)
	
	obstacles.add_child(platform)

func cleanup_platforms() -> void:
	for child in obstacles.get_children():
		if child.global_position.x < camera.global_position.x - threshold_range:
			child.queue_free()


func _on_lava_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# after physics stuff
		get_tree().change_scene_to_file.call_deferred("res://scenes/parkour/death_display.tscn")
