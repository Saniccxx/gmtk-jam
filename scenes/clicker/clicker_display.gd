extends Node2D

var clicks_needed: int = 10
var current_clicks: int = 0
@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var labeltimer: Label = $Label2

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start(5.0)
	
func _process(_delta: float) -> void:
	labeltimer.text = "Time left: %.1f seconds" % max(0.0, timer.time_left)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("accept"):
		current_clicks += 1
		label.text = "Mash Space! %d/%d" % [current_clicks, clicks_needed]
		
		if current_clicks >= clicks_needed:
			get_tree().change_scene_to_file("res://scenes/parkour/winner_display.tscn")

func _on_timer_timeout() -> void:
	if current_clicks < clicks_needed:
		get_tree().change_scene_to_file("res://scenes/parkour/death_display.tscn")
