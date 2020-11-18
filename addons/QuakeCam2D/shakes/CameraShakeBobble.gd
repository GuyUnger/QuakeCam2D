extends CameraShake
class_name CameraShakeBobble

var angle_off:float
var cycle:float
var direction:int

func _init(duration:float, amplitude:float, frequency:float, start_angle:float, direction:int):
	init(duration, amplitude, frequency)
	if direction == 0:
		self.direction = (randi() % 2) * 2 - 1
	else:
		self.direction = sign(direction)
	cycle = start_angle

func _update_offset(delta):
	cycle += frequency * direction * delta
	angle = sin(cycle * TAU) * amplitude
