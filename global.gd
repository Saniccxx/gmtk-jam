extends Node


signal gun_changed
var map_pos: Vector2 = Vector2(0,0)
var money: int = 9999
var best_owned_gun: int = 3
enum Difficulty { EASY, MEDIUM, HARD }
var current_difficulty: Difficulty = Difficulty.EASY

var weapons: Array[Weapon] = [
	Weapon.new("pistol", 0, "res://assets/pistoleciki/Untitled-5.png", 1, 0.1, false, [15, 18], 12, 12, 1.0),
	Weapon.new("uzi", 100, "res://assets/pistoleciki/Untitled-4.png", 1, 0.1, true, [9, 9], 50, 50, 1.7),
	Weapon.new("shotgun", 2000, "res://assets/pistoleciki/Untitled-6.png", 15, 0.4, false, [30, 30], 10, 10, 2.0, 20.0, 1),
	Weapon.new("machinegun", 100000, "res://assets/pistoleciki/Untitled-7.png", 1, 0.05, true, [6.7, 3], 150, 150, 2.5)
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
	var pierce: int
	var recoil: Array
	var ammo: int
	var zombie_ammo: int
	var reload_time: float

	func _init(_name: String, _cost: int, _img_path: String, 
	_bullets_per_shot: int, _fire_delay: float, _is_auto: bool,
	_recoil: Array, _ammo: int, _zombie_ammo: int, _reload_time: float, 
	_spread_angle: float = 0.0, _pierce: int = 0) -> void:
		name = _name
		cost = _cost
		img_path = _img_path
		bullets_per_shot = _bullets_per_shot
		fire_delay = _fire_delay
		is_auto = _is_auto
		spread_angle = _spread_angle
		pierce = _pierce
		recoil = _recoil
		ammo = _ammo
		zombie_ammo = _zombie_ammo
		reload_time = _reload_time
