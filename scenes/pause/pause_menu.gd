extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			close()
		else:
			open()
		get_viewport().set_input_as_handled()

func open() -> void:
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	close()

func _on_map_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")

func _on_main_menu_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
