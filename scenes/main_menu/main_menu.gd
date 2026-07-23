extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits_display.tscn")
