extends Node2D
@onready var lives_left: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Pointer.damage.connect(_remove_heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _remove_heart():
	if lives_left == 3:
		$Hud/CanvasLayer2/Hearts/TextureRect3/Heart3.play("Broken")
	elif lives_left == 2:
		$Hud/CanvasLayer2/Hearts/TextureRect2/Heart2.play("Broken")
	if lives_left == 1:
		$Hud/CanvasLayer2/Hearts/TextureRect/Heart1.play("Broken")
	lives_left -= 1
	
