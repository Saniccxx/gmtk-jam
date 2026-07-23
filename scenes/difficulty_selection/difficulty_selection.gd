extends Control

func _on_easy_pressed() -> void:
	global.current_difficulty = global.Difficulty.EASY
	start_game()

func _on_medium_pressed() -> void:
	global.current_difficulty = global.Difficulty.MEDIUM
	start_game()

func _on_hard_pressed() -> void:
	global.current_difficulty = global.Difficulty.HARD
	start_game()

func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/zombie/zombie_game.tscn")
