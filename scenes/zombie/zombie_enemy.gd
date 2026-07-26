extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 10
@export var attack_speed: float = 1.0
@export var health: int = 30
@export var base_reward: int = 50
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown: Timer = $AttackCooldown
var player_in_range: bool = false
signal died

var player: CharacterBody2D = null

func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	add_to_group("enemy")
	attack_cooldown.wait_time = attack_speed

func _on_hitbox_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if body.has_method("take_damage"):
			body.take_damage(damage)
			attack_cooldown.start()

func _on_hitbox_body_exited(body: Node2D) -> void:
	player_in_range = false
	attack_cooldown.stop()

func _on_attack_cooldown_timeout() -> void:
	if player_in_range and player and player.has_method("take_damage"):
		player.take_damage(damage)

func _physics_process(_delta: float) -> void:
	if player:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		if direction.x < 0:
			sprite.flip_h = false
		elif direction.x > 0:
			sprite.flip_h = true
	
	

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		died.emit()
		global.add_zombie_kill_reward(base_reward) # Award points on kill
		queue_free()
