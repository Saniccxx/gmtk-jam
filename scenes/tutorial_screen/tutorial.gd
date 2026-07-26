extends CanvasLayer
@export var mode: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(mode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_map_pressed() -> void:
	visible = false


func _on_play_pressed() -> void:
	pass # Replace with function body.
