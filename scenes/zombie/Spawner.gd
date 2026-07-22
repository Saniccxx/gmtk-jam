extends Node2D

@export var enemy_scene: PackedScene = preload("res://scenes/zombie/zombie_enemy.tscn")
@onready var spawn_timer: Timer = $SpawnTimer
var margin: float = 100.0

signal enemy_spawned

func _ready() -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	spawn_enemy_outside()

#func spawn_enemy() -> void:
#	var enemy: Node2D = enemy_scene.instantiate()
#	enemy.global_position = get_random_spawn_position()
#	add_child(enemy)
#	enemy_spawned.emit()

#func get_random_spawn_position() -> Vector2:
#	var x: float = randf_range(100.0, 1820.0)
#	var y: float = randf_range(100.0, 980.0)
#	return Vector2(x, y)

func spawn_enemy_outside() -> void:
	if enemy_scene == null:
		return
	var enemy: Node = enemy_scene.instantiate()
	enemy.global_position = get_random_outside_position()
	add_child(enemy)
	enemy_spawned.emit()

func get_random_outside_position() -> Vector2:
	var screen_size: Vector2 = get_viewport_rect().size
	var side: int = randi() % 4
	var spawn_pos: Vector2 = Vector2.ZERO

	match side:
		0:
			spawn_pos.x = randf_range(0, screen_size.x)
			spawn_pos.y = -margin

		1:
			spawn_pos.x = randf_range(0, screen_size.x)
			spawn_pos.y = screen_size.y + margin

		2:
			spawn_pos.x = -margin
			spawn_pos.y = randf_range(0, screen_size.y)

		3:
			spawn_pos.x = screen_size.x + margin
			spawn_pos.y = randf_range(0, screen_size.y)

	return spawn_pos

