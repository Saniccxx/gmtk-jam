extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MapPlayer").position = global.map_pos
	pass

var minigames = [
	#"res://scenes/parkour/parkour_display.tscn",
	"res://scenes/target/target_display.tscn",
	#"res://scenes/zombie/zombie_game.tscn"
]
func change_scene_random():
	global.map_pos = get_node("MapPlayer").position
	var random_game = minigames[randi() % minigames.size()]
	get_tree().change_scene_to_file(random_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		change_scene_random()
	if Input.is_action_just_pressed("slide"):
		get_tree().change_scene_to_file("res://scenes/shop/shop_display.tscn")
