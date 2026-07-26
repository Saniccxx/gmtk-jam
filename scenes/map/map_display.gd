extends Node2D

@onready var map_player: CharacterBody2D = $MapPlayer
@onready var prompt_layer: CanvasLayer = $PromptLayer
@onready var interact_label: Label = $PromptLayer/PopupPanel/PromptLabel

var minigames := {
	"parkour": "res://scenes/parkour/parkour_display.tscn",
	"target": "res://scenes/target/target_display.tscn",
	"zombie": "res://scenes/difficulty_selection/difficulty_selection.tscn",
	"shop": "res://scenes/shop/shop_display.tscn"
}

var zone_display_names := {
	"parkour": "Parkour",
	"target": "Target Practice",
	"zombie": "Zombie Survival",
	"shop": "Shop"
}

var current_zones: Array[String] = []

func _ready() -> void:
	if global.map_pos != Vector2.ZERO:
		map_player.position = global.map_pos

	$ParkourArea.body_entered.connect(_on_zone_entered.bind("parkour"))
	$ParkourArea.body_exited.connect(_on_zone_exited.bind("parkour"))

	$TargetArea.body_entered.connect(_on_zone_entered.bind("target"))
	$TargetArea.body_exited.connect(_on_zone_exited.bind("target"))

	$ZombieArea.body_entered.connect(_on_zone_entered.bind("zombie"))
	$ZombieArea.body_exited.connect(_on_zone_exited.bind("zombie"))

	$ShopArea.body_entered.connect(_on_zone_entered.bind("shop"))
	$ShopArea.body_exited.connect(_on_zone_exited.bind("shop"))

	prompt_layer.visible = false

func _on_zone_entered(body: Node, zone_name: String) -> void:
	if body != map_player:
		return
	if not current_zones.has(zone_name):
		current_zones.append(zone_name)
	_update_prompt()

func _on_zone_exited(body: Node, zone_name: String) -> void:
	if body != map_player:
		return
	current_zones.erase(zone_name)
	_update_prompt()

func _update_prompt() -> void:
	if current_zones.is_empty():
		prompt_layer.visible = false
		return
		
	var zone_name: String = current_zones[current_zones.size() - 1]
	
	if zone_name == "shop":
		interact_label.text = "Press Enter to Enter Shop"
	else:
		interact_label.text = "Press Enter to Enter " + zone_display_names[zone_name] + ""
		
	prompt_layer.visible = true

func enter_game(zone_name: String) -> void:
	global.map_pos = map_player.position
	$Tutorial.true_ready(minigames[zone_name])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept") and not current_zones.is_empty():
		enter_game(current_zones[current_zones.size() - 1])
