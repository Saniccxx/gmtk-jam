extends Node


signal gun_changed
var map_pos: Vector2 = Vector2(0,0)
var money: int = 9999
var gun_names: Array[String] = ["pistol", "uzi", "shotgun", "machinegun"]
var gun_costs: Array[int] = [0, 100, 2000, 100000]
var gun_imgs: Array[String] = ["res://assets/pistol.png", "res://assets/uzi.png", "res://assets/shotgun.jpg", "res://assets/machinegun.jpg"]
var best_owned_gun: int = 3

var weapons: Array[Weapon] = [
	Weapon.new("pistol", 0, "res://assets/pistol.png", 1, 0.1, false),
	Weapon.new("uzi", 100, "res://assets/uzi.png", 1, 0.1, true),
	Weapon.new("shotgun", 2000, "res://assets/shotgun.jpg", 15, 0.4, false, 20.0),
	Weapon.new("machinegun", 100000, "res://assets/machinegun.jpg", 1, 0.05, true)
]

var current_gun: int = 0

var last_minigame_path: String = ""

func set_current_gun(new_gun):
	current_gun = new_gun
	gun_changed.emit()

func load_death_screen() -> void:
	last_minigame_path = get_tree().current_scene.scene_file_path
	get_tree().call_deferred("change_scene_to_file", "res://scenes/death/death_display.tscn")

func load_winner_screen() -> void:
	last_minigame_path = get_tree().current_scene.scene_file_path
	get_tree().call_deferred("change_scene_to_file", "res://scenes/win/winner_display.tscn")

class Weapon:
	var name: String
	var cost: int
	var img_path: String
	var bullets_per_shot: int
	var fire_delay: float
	var is_auto: bool
	var spread_angle: float
	func _init(_name: String, _cost: int, _img_path: String, _bullets_per_shot: int, _fire_delay: float, _is_auto: bool, _spread_angle: float = 0.0) -> void:
		name = _name
		cost = _cost
		img_path = _img_path
		bullets_per_shot = _bullets_per_shot
		fire_delay = _fire_delay
		is_auto = _is_auto
		spread_angle = _spread_angle
