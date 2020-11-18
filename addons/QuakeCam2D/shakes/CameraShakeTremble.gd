extends CameraShake
class_name CameraShakeTremble

var direction:Vector2
var direction_dir:int = 1

func _init(duration:float, amplitude:float, direction:float):
	init(duration, amplitude)
	self.direction = Vector2.RIGHT.rotated(direction)

func _update_offset(delta):
	offset = direction * direction_dir * amplitude
	direction_dir *= -1
