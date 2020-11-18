extends CameraShake
class_name CameraShakeWobble

var speed:float
var speed_random:float
var cycle:float = .5

var offset_from:float
var offset_to:float

func _init(duration:float, amplitude:float, frequency:float, direction:int):
	init(duration, amplitude, frequency)
	if direction == 0:
		direction = (randi() % 2) * 2 - 1
	offset_to = direction * amplitude
	offset_from = -offset_to
	speed_random = 1.2

func _update_offset(delta):
	cycle += frequency * 2 * speed_random * delta
	if cycle >= 1:
		cycle -= 1
		offset_from = offset_to
		speed_random = 1 + rand_range(-1, 1) * .2
		offset_to = rand_range(.5, 1) * -sign(offset_to) * amplitude
	
	angle = lerp(offset_from, offset_to, ease(cycle, -2))
