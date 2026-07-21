extends Area2D

@export var speed: float = 500.0
@export var damage: int = 15

func _ready() -> void:
	$CollisionShape2D.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
#	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
