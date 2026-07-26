extends Parallax2D

@export var cloud_count: int = 14
@export var spacing: float = 900.0
@export var y_base: float = 100.0
@export var y_range: float = 200.0
@export var scale_range: Vector2 = Vector2(0.6, 1.2)

var cloud_textures: Array[Texture2D] = []

func _ready() -> void:
	for i in range(1, 6):
		cloud_textures.append(load("res://scenes/parkour/assets/jeicam/chmurki/chmukra (%d).png" % i))

	var start_offset := -cloud_count / 2.0 * spacing

	for i in range(cloud_count):
		var cloud := Sprite2D.new()
		cloud.texture = cloud_textures[randi() % cloud_textures.size()]
		cloud.position = Vector2(
			start_offset + i * spacing + randf_range(-100.0, 100.0),
			y_base + randf_range(-y_range, y_range)
		)
		var s := randf_range(scale_range.x, scale_range.y)
		cloud.scale = Vector2(s, s)
		add_child(cloud)

	scroll_scale = Vector2(0.25, 0.05)
	repeat_size = Vector2(cloud_count * spacing, 0.0)
