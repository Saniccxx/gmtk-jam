extends Node2D

var enemies_left: int = 0

func _ready() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemy")
	enemies_left = enemies.size()
	for enemy in enemies:
		enemy.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	enemies_left -= 1
	if enemies_left <= 0:
		global.load_winner_screen()