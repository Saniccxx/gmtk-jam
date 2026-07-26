extends Sprite2D

@export var wobble_amplitude_deg: float = 10.0
@export var wobble_speed: float = 0.15

func _process(_delta: float) -> void:
	rotation = deg_to_rad(sin(Time.get_ticks_msec() / 1000.0 * wobble_speed) * wobble_amplitude_deg)
