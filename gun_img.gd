extends TextureRect
@onready var current = global.current_gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(global.gun_imgs[current])
	texture = load(global.gun_imgs[current])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current = global.current_gun
	texture = load(global.gun_imgs[current])
