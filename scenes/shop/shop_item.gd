extends Control

@export var item_num: String
@export var item_icon: Texture2D

@onready var label = $VBoxContainer/Label
@onready var button = $VBoxContainer/Button

func _ready():
	label.text = str(global.gun_costs[int(item_num)])
	button.icon = item_icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.best_owned_gun >= int(item_num):
		Label.text = "Owned"
	pass
	
