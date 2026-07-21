extends Control


func _on_retry_pressed() -> void:
	pass # Replace with function body.


func _on_map_display_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")
