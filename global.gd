extends Node

var map_pos = Vector2(0,0)
var money = 9999
var gun_names = ["pistol", "uzi", "shotgun", "machinegun"]
var gun_costs = [0, 100, 2000, 100000]
var gun_imgs = ["res://assets/pistol.png", "res://assets/machinegun.jpg", "res://assets/shotgun.jpg", "res://assets/uzi.png"]
var best_owned_gun = 0
var current_gun = 0

var last_minigame_path: String = ""

func load_death_screen() -> void:
	last_minigame_path = get_tree().current_scene.scene_file_path
	get_tree().call_deferred("change_scene_to_file", "res://scenes/death/death_display.tscn")

func load_winner_screen() -> void:
	last_minigame_path = get_tree().current_scene.scene_file_path
	get_tree().call_deferred("change_scene_to_file", "res://scenes/win/winner_display.tscn")
