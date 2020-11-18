extends CameraShake
class_name CameraShakeQuake

var speed:float
var cycle:float = 1

var offset_angle:float
var offset_from:Vector2
var offset_to:Vector2
var randomness:float
var speed_random:float = 1.2

func _init(duration:float, amplitude:float, frequency:float, randomness:float = 1):
	init(duration, amplitude, frequency)
	offset_angle = randf() * TAU
	self.randomness = randomness

func _update_offset(delta):
	cycle += frequency * delta * speed_random
	if cycle >= 1:
		cycle -= 1
		offset_angle += PI + rand_range(-1, 1) * 1.5 * randomness
		offset_from = offset_to
		offset_to = Vector2.RIGHT.rotated(offset_angle) * rand_range(.5, 1) * amplitude
		speed_random = 1 + rand_range(-1, 1) * .2
	
	offset = offset_from.linear_interpolate(offset_to, ease(cycle, -2))
