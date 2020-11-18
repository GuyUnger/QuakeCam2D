extends CameraShake
class_name CameraShakeBuzz

var cycle:float

func _init(duration:float, amplitude:float):
	init(duration, amplitude)
	cycle = randf() * TAU

func _update_offset(delta):
	cycle += PI * (1 + rand_range(-1, 1) * .5)
	offset = Vector2.RIGHT.rotated(cycle)
	offset *= amplitude
