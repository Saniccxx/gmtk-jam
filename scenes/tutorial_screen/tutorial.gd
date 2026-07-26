extends CanvasLayer
@export var mode: String
@onready var title_label = $ColorRect/VBoxContainer/Title
@onready var tresc_label = $ColorRect/VBoxContainer/Tresc
# Called when the node enters the scene tree for the first time.

var target_tresc = "Shoot the targets when they spawn
 The closer to the middle,
 the more tickets you get
 But don't miss, or else...
 Move - WASD, shoot - LMB, sprint - RMB"

var zombie_tresc = "Shoot your way through the horde
zombies will come
you need to survive
Move - WASD, Shoot - LMB"

var parkour_tresc = "Run and jump as fast as you can
use gun recoil to help you
but be careful not to fall
into the gaping pit below"

func _ready() -> void:
	print(mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_correct_game(game):
	if game == "res://scenes/shop/shop_display.tscn":
		visible = false
		get_tree().change_scene_to_file("res://scenes/shop/shop_display.tscn")
		return
	if game == "res://scenes/target/target_display.tscn":
		title_label.text = "Target Practice"
		tresc_label.text = target_tresc
	elif game == "res://scenes/difficulty_selection/difficulty_selection.tscn":
		title_label.text = "Zombie Survival"
		tresc_label.text = zombie_tresc
	elif game == "res://scenes/parkour/parkour_display.tscn":
		title_label.text = "Parkour"
		tresc_label.text = parkour_tresc
		



func _on_map_pressed() -> void:
	visible = false

func true_ready(tryb):
	mode = tryb
	visible = true
	print(tryb)
	set_correct_game(tryb)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file(mode)
