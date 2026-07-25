extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mom/dialog_display.tscn")
	TimerGlobal.start()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits_display.tscn")
