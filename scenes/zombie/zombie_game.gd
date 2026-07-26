extends Node2D

var enemies_left: int = 0
@export var time_label: Label
@export var health_label: Label
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $ZombiePlayer
@onready var ammo_label: Label = $CanvasLayer/MarginContainer/ZombieHUD/Ammo
@onready var reloading_label: Label = $CanvasLayer/Reloading

var reward: int = 0

func _ready() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	enemies_left = enemies.size()
	player.update_labels.connect(_update_labels)
	$Enemies.enemy_spawned.connect(_on_enemy_spawned)
	for enemy in enemies:
		enemy.died.connect(_on_enemy_died)
	match global.current_difficulty:
		global.Difficulty.EASY:
			reward = 500
		global.Difficulty.MEDIUM:
			reward = 1000
		global.Difficulty.HARD:
			reward = 2000

func _on_enemy_spawned() -> void:
	enemies_left += 1

func _update_labels() -> void:
	ammo_label.text = str(player.current_ammo[global.current_gun]) + " / " + str(player.ammunition[global.current_gun])
	reloading_label.visible = player.is_reloading
	if global.current_gun == 3:
		$ZombiePlayer.ShootingSound = $SFX/Machinegun
	elif global.current_gun == 2:
		$ZombiePlayer.ShootingSound = $SFX/Shotgun
	else:
		$ZombiePlayer.ShootingSound = $SFX/ShootingSound

func _process(_delta: float) -> void:
	if time_label:
		var time_left: int = $Timer.time_left
		time_label.text = str(time_left) + "s"

	if player:
		if health_label:
			health_label.text = "HP: " + str(player.health if player.health > 0 else "0")

func _on_enemy_died() -> void:
	enemies_left -= 1

func _on_timer_timeout() -> void:
	global.money += reward
	global.load_winner_screen()
