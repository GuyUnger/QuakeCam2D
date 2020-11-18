extends CameraShake
class_name CameraShakeShock

func _init(duration:float, amplitude:float):
	init(duration, amplitude)

func _update_offset(delta):
	offset = Vector2.RIGHT.rotated(randf() * TAU) * amplitude * randf()
