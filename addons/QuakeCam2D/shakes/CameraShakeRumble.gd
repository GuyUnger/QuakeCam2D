extends CameraShake
class_name CameraShakeRumble

var speed:float
var direction:int
var cycle:float

func _init(duration:float, amplitude:float, frequency:float, direction:int):
	init(duration, amplitude, frequency)
	if direction == 0:
		self.direction = (randi() % 2) * 2 - 1
	else:
		self.direction = sign(direction)
	
	cycle = randf() * TAU

func _update_offset(delta):
	cycle += frequency * TAU * direction * delta
	offset = Vector2.RIGHT.rotated(cycle) * amplitude
