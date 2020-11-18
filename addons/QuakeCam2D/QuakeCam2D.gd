extends Camera2D
class_name QuakeCam2D

var shakes:Array
var shake_offset:Vector2
var shake_angle:float
var shake_zoom:Vector2

var shake_strength:float = 1

var default_listener:Node2D = self

# Swings the camera around the center
func shake_rumble(duration:float = .5, amplitude:float = 10, frequency:float = 5, direction:int = 0)->CameraShake:
	return add_shake(CameraShakeRumble.new(duration, amplitude, frequency, direction))

# Shakes around smoothly
func shake_quake(duration:float = 1, amplitude:float = 10, frequency:float = 20, randomness:float = 1):
	return add_shake(CameraShakeQuake.new(duration, amplitude, frequency, randomness))

# Moves the camera in a direction and smoothly tweens it back
# tip: the easing can be influenced by setting the amplitude curve ie. amplitude_in(1), amplitude_out(1.5)
func shake_pull(duration:float = .5, amplitude:float = 10, direction:float = -1.570796)->CameraShake:
	return add_shake(CameraShakePull.new(duration, amplitude, direction))

# A vicious random shake that makes sure the camera moves almost the whole amplitude each frame
func shake_buzz(duration = .5, amplitude = 10)->CameraShake:
	return add_shake(CameraShakeBuzz.new(duration, amplitude))

# The most random of all. Sets a random direction and amplitude each frame
func shake_shock(duration:float = .3, amplitude:float = 7)->CameraShake:
	return add_shake(CameraShakeShock.new(duration, amplitude))

# Wobbles back and forth in a certain direction
func shake_wave(duration:float = .5, amplitude:float = 10, frequency:float = 5, direction:float = -1.570796)->CameraShake:
	return add_shake(CameraShakeWave.new(duration, amplitude, frequency, direction))
# Moves the camera back and forth the whole amplitude each frame, best used with a limited frame rate
# tip: to set the framerate use ` camera.shake_tramble().limit_fps(12) `
func shake_tremble(duration:float = .5, amplitude:float = 10, direction:float = -1.570796)->CameraShake:
	return add_shake(CameraShakeTremble.new(duration, amplitude, direction))

# Wobbles the camera angle like an indian
func shake_bobble(duration:float = .5, amplitude:float = 3, frequency:float = 4, start_angle:float = 0, direction:int = 0)->CameraShake:
	return add_shake(CameraShakeBobble.new(duration, deg2rad(amplitude), frequency, start_angle, direction))

func shake_wobble(duration:float = .5, amplitude:float = 3, frequency:float = 4, direction:int = 0)->CameraShake:
	return add_shake(CameraShakeWobble.new(duration, deg2rad(amplitude), frequency, direction))

# Moves the camera around randomly similar to a camera being held in hand
# tip: works well if you set the duration to -1 (so it never stops) and store the shake as a variables so you can pause() and play() it
func shake_handheld(duration:float = 1, amplitude:float = 10, speed:float = 1)->CameraShake:
	return add_shake(CameraShakeHandheld.new(duration, amplitude, speed))

func shake_flinch(duration:float = .2, amplitude:float = .02, direction:int = 1)->CameraShake:
	return add_shake(CameraShakeFlinch.new(duration, amplitude, direction))

func add_shake(shake:CameraShake):
	shakes.push_back(shake)
	shake.listener = default_listener
	return shake

func stop_all_shakes():
	for shake in shakes:
		shake.clean()
	shakes.clear()

func _process(delta):
	process_shakes(delta)
	rotation = shake_angle * shake_strength
	offset = shake_offset * shake_strength
	zoom = shake_zoom * shake_strength

func process_shakes(delta):
	shake_angle = 0
	shake_offset = Vector2()
	shake_zoom = Vector2.ONE
	for i in range(shakes.size() - 1, -1, -1):
		var shake = shakes[i]
		if shake.is_completed():
			shake.clean()
			shakes.remove(i)
		else:
			shake_offset += shake.process(delta)
			shake_angle += shake.angle
			shake_zoom *= Vector2.ONE + shake.zoom
