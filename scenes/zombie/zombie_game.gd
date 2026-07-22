extends Node2D

var enemies_left: int = 0
@export var time_label: Label
@export var health_label: Label
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $ZombiePlayer

func _ready() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	enemies_left = enemies.size()
	for enemy in enemies:
		enemy.died.connect(_on_enemy_died)

func _process(delta: float) -> void:
	if time_label:
		var time_left: int = $Timer.time_left
		time_label.text = str(time_left) + "s"

	if player:
		if health_label:
			health_label.text = "HP: " + str(player.health if player.health > 0 else "0")

func _on_enemy_died() -> void:
	enemies_left -= 1
	if enemies_left <= 0:
		global.load_winner_screen()


func _on_timer_timeout() -> void:
	global.load_winner_screen()
