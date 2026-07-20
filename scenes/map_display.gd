extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MapPlayer").position = global.map_pos
	pass

func change_scene(go_to):
	global.map_pos = get_node("MapPlayer").position
	get_tree().change_scene_to_file(go_to)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		change_scene("res://minigames/parkour/parkour_display.tscn")
