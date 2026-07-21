extends Control

func _on_retry_pressed() -> void:
	pass


func _on_map_display_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")
