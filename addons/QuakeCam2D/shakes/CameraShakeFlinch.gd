extends CameraShake
class_name CameraShakeFlinch

var direction

func _init(duration:float, amplitude:float, direction:int = 1):
	amplitude_out(1)
	init(duration, amplitude)
	self.direction = sign(direction)

func _update_offset(delta):
	zoom = Vector2.ONE * amplitude * direction
