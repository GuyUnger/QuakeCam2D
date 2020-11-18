extends CameraShake
class_name CameraShakePull

var direction:Vector2

func _init(duration:float, amplitude:float, direction:float):
	init(duration, amplitude)
	self.direction = Vector2.RIGHT.rotated(direction)

func _update_offset(delta):
	offset = direction * t * amplitude
