extends CharacterBody2D

@export var speed: float = 600.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D




func _ready() -> void:
	add_to_group("player")

func play_animation(anim_name: String) -> void:
	match anim_name:
		"idle":
			animated_sprite.position = Vector2(-6, -53)
			animated_sprite.scale = Vector2(0.725, 0.725)
		"run":
			animated_sprite.position = Vector2(-40 if not animated_sprite.flip_h else 20, -98)
			animated_sprite.scale = Vector2(1.035, 1.035)
	animated_sprite.play(anim_name)

func update_animation(dir: Vector2) -> void:
	if dir != Vector2.ZERO:
		play_animation("run")
	else:
		play_animation("idle")
		
	if dir.x < 0:
		animated_sprite.flip_h = true
	elif dir.x > 0:
		animated_sprite.flip_h = false

func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	move_and_slide()
	
	update_animation(input_vector)



#func _input(event: InputEvent) -> void:
#	pass
