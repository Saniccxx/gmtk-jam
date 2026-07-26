extends Control
var dialogue_tree := {
	"start": {
		"speaker": "Mom",
		"text": "Okay! We gotta go now, you have DEUSTCH test tomorrow.",
		"next": "kid_choice"
	},
	"kid_choice": {
		"speaker": "Kid",
		"text": "Can I still play?!",
		"choices": [
			{"text": "\"Please, just a little while?\"", "next": "mom_response_asking"},
			{"text": "\"One more time! I'm gonna win big!\"", "next": "mom_response_confident"},
			{"text": "\"Bruh I still haven't beaten this guy, i need more time.\"", "next": "mom_response_pushy"}
		]
	},
	"mom_response_asking": {
		"speaker": "Mom",
		"text": "Aww, of course sweetie. I'm not in a rush.",
		"next": "mom_grants_time"
	},
	"mom_response_confident": {
		"speaker": "Mom",
		"text": "That's the spirit! Just don't gamble everything!",
		"next": "mom_grants_time"
	},
	"mom_response_pushy": {
		"speaker": "Mom",
		"text": "Let's not push it - you need to prepare for the exam.",
		"next": "mom_grants_time"
	},
	"mom_grants_time": {
		"speaker": "Mom",
		"text": "Here's the deal: you have 10 minutes. Try to earn 100,000 credits before time's up, okay?",
		"next": "kid_final"
	},
	"kid_final": {
		"speaker": "Kid",
		"text": "Got it! Ten minutes, 100,000 credits. I'm on it!",
		"next": "end"
	},
	"end": {
		"speaker": "",
		"text": "",
		"end": true
	}
}
var current_node_id := "start"
@onready var dialog_box: TextureRect = $DialogBox
@onready var text_label: Label = $DialogBox/TextLabel
@onready var continue_hint: Label = $DialogBox/ContinueHint
@onready var choices_container: VBoxContainer = $ChoicesContainer
@onready var mom_portrait: TextureRect = $Mom
@onready var kid_portrait: TextureRect = $Kid
const BUBBLE_SIZE := Vector2(800, 300)
const BUBBLE_PADDING := 20.0
const TAIL_DEFAULT_DIRECTION := "left"
func _ready() -> void:
	choices_container.visible = false
	continue_hint.visible = false
	dialog_box.size = BUBBLE_SIZE
	_show_node(current_node_id)
func _show_node(node_id: String) -> void:
	current_node_id = node_id
	var node: Dictionary = dialogue_tree[node_id]
	if node.get("end", false):
		_finish_dialogue()
		return
	text_label.text = node["text"]
	_highlight_speaker(node["speaker"])
	_position_bubble(node["speaker"])
	for child in choices_container.get_children():
		child.queue_free()
	if node.has("choices"):
		dialog_box.visible = false
		continue_hint.visible = false
		choices_container.visible = true
		for choice in node["choices"]:
			var btn := Button.new()
			btn.text = choice["text"]
			btn.pressed.connect(_on_choice_selected.bind(choice["next"]))
			choices_container.add_child(btn)
	else:
		dialog_box.visible = true
		choices_container.visible = false
		continue_hint.visible = true
func _highlight_speaker(speaker: String) -> void:
	mom_portrait.modulate = Color(1, 1, 1, 1) if speaker == "Mom" else Color(0.45, 0.45, 0.45, 1)
	kid_portrait.modulate = Color(1, 1, 1, 1) if speaker == "Kid" else Color(0.45, 0.45, 0.45, 1)
func _position_bubble(speaker: String) -> void:
	var portrait: TextureRect = mom_portrait if speaker == "Mom" else kid_portrait
	var tail_direction: String
	if portrait == mom_portrait:
		dialog_box.position = Vector2(
			portrait.offset_right + BUBBLE_PADDING,
			portrait.offset_top + BUBBLE_PADDING
		)
		tail_direction = "left"
	else:
		dialog_box.position = Vector2(
			portrait.offset_left - BUBBLE_SIZE.x - BUBBLE_PADDING,
			portrait.offset_top - BUBBLE_PADDING
		)
		tail_direction = "right"
	dialog_box.flip_h = tail_direction != TAIL_DEFAULT_DIRECTION
func _on_choice_selected(next_id: String) -> void:
	_show_node(next_id)
func _process(_delta: float) -> void:
	if continue_hint.visible and Input.is_action_just_pressed("accept"):
		var node: Dictionary = dialogue_tree[current_node_id]
		if node.has("next"):
			_show_node(node["next"])
func _finish_dialogue() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")
	TimerGlobal.start()
