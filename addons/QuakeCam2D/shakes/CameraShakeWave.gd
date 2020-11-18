extends CameraShake
class_name CameraShakeWave

var speed:float
var direction:Vector2
var cycle:float

func _init(duration:float, amplitude:float, frequency:float, direction:float):
	init(duration, amplitude, frequency)
	self.direction = Vector2.RIGHT.rotated(direction)

func _update_offset(delta):
	cycle += frequency * TAU * delta
	offset = direction * cos(cycle) * amplitude
