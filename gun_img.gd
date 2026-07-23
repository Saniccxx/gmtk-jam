extends TextureRect
@onready var current = global.current_gun


func update_img():
	current = global.current_gun
	texture = load(global.weapons[current].img_path)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = load(global.weapons[current].img_path)
	global.gun_changed.connect(update_img)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
