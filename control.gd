extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_down"):
		if global.current_gun > 0:
			global.current_gun -= 1
			$Gun_img.update_img()
	if Input.is_action_just_pressed("scroll_up"):
		if global.current_gun < global.best_owned_gun:
			global.current_gun += 1
			$Gun_img.update_img()
		
		
