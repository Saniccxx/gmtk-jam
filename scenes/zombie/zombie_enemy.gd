extends CharacterBody2D

@export var speed: float = 100.0
@export var damage: int = 10
@export var health: int = 30
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal died

var player: CharacterBody2D = null

func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	add_to_group("enemy")

func _on_hitbox_body_entered(body) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

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
		queue_free()
