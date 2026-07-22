extends Node
@export var target_scene: PackedScene
const padding = 100
func get_spawn_spot():
	var viewport_size = get_parent().get_viewport_rect().size
	var x = randf_range(padding, viewport_size.x - padding)
	var y = randf_range(padding, viewport_size.y - padding)
	return Vector2(x, y)

func spawn():
	var target = target_scene.instantiate()
	get_parent().get_node("All_targets").add_child(target)
	target.global_position = get_spawn_spot()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	spawn()
