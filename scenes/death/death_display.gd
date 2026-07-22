extends Control

func _on_retry_pressed() -> void:
	if global.last_minigame_path != "":
		get_tree().change_scene_to_file(global.last_minigame_path)

func _on_map_display_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credit_display.tscn")
