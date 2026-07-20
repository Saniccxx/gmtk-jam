extends Label

@onready var player = $"../../Player"

func _process(_delta: float) -> void:
	if player:
		var distance = int(player.global_position.x)
		text = str(distance/100) + "/1000"
