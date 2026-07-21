extends Control

@export var item_num: String
@export var item_icon: Texture2D


@onready var label = $VBoxContainer/Label
@onready var button = $VBoxContainer/Button
@onready var cost = global.gun_costs[int(item_num)]

func _ready():
	label.text = str(cost)
	button.icon = item_icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.best_owned_gun >= int(item_num):
		label.text = "Owned"
	pass
	


func _on_button_pressed() -> void:
	if label.text == "Owned":
		return
	if global.money < cost:
		print("can't afford")
		return
	if int(item_num) > global.best_owned_gun + 1:
		return
	global.money -= cost
	global.best_owned_gun += 1
	global.current_gun = global.best_owned_gun
