extends CameraShake
class_name CameraShakeHandheld

var speed:float

var noise = OpenSimplexNoise.new()
var sample_i:float

func _init(duration:float, amplitude:float, speed:float):
	init(duration, amplitude)
	self.speed = speed
	
	noise.seed = randi()
	noise.octaves = 5
	noise.period = 10.0
	noise.persistence = 0.8
	
	sample_i = randf() * 999

func _update_offset(delta):
	sample_i += delta * speed
	offset = Vector2(
		noise.get_noise_1d(sin(sample_i + 99)) - noise.get_noise_1d(sin(sample_i * 1.1 + 999)),
		noise.get_noise_1d(sin(sample_i * .8) - noise.get_noise_1d(sin(sample_i * .7 + 9999)))
	) * 2.0
	angle = (noise.get_noise_1d(sin(sample_i * .5 + 999)) - noise.get_noise_1d(sin(sample_i * .7 + 99))) * .03
	angle += offset.x * offset.y * .1
	offset *= amplitude
