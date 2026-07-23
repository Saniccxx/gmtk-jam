extends Area2D

@export var speed: float = 2000.0
@export var damage: int = 30

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
#	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	position += transform.x * speed * delta

#func _on_body_entered(body: Node2D) -> void:
	#if body.get_parent().has_method("take_damage"):
		#body.get_parent().take_damage(damage)
	#queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage)
	queue_free()
