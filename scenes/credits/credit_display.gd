extends Control



const CREDITS := {
	"res://scenes/parkour/parkour_display.tscn": {"game": "PARKOUR", "creator": "ruter"},
	"res://scenes/zombie/zombie_game.tscn": {"game": "ZOMBIE", "creator": "sani"},
	"res://scenes/target/target_display.tscn": {"game": "TARGET", "creator": "bombias"},
}

func _ready() -> void:
	var info: Dictionary = CREDITS.get(global.last_minigame_path, {"game": "how did we", "creator": "get here"})
	%GameLabel.text = info["game"]
	%CreatorLabel.text = "made by " + info["creator"]

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/map_display.tscn")
