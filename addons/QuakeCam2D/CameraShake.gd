extends Object
class_name CameraShake

var offset:Vector2
var angle:float
var zoom:Vector2

var t_raw:float = 1
var t:float = 1
var duration:float
var amplitude:float
var amplitude_curve:float = .5
var hold_t:float
var boost_t:float
var boost_multi:float
var frequency:float
var frequency_curve:float = .5

# Fps limiting
var fps:int
var frame_current:float
var frame_last:float

# Playback
var playing:bool = true
var reversed:bool

# Caller and listener
enum ListenMode {global, position, node2D}
var listen_mode:int
var listener:Node2D
var caller_position:Vector2
var caller_node:Node2D
var listen_amplitude_min:float
var listen_amplitude_max:float

func init(duration:float, amplitude:float, frequency:float = 1):
	self.duration = duration
	self.amplitude = amplitude
	self.frequency = frequency

func is_completed()->bool:
	return t_raw <= 0

func process(delta, force:bool = false)->Vector2:
	if (playing and hold_t <= 0) or force:
		
		t = t_raw
		if reversed:
			t = 1 - t
		
		var do_update:bool = true
		if fps > 0:
			frame_current += delta * fps
			if frame_current > frame_last + 1:
				frame_last += 1
				var _delta = 1 / fps
				if frequency_curve != 0:
					_delta *= ease(t, frequency_curve)
				update_offset(_delta)
		else:
			var _delta = delta
			if frequency_curve != 0:
					_delta *= ease(t, frequency_curve)
			update_offset(_delta)
		
		if listen_mode != ListenMode.global:
			var listen_amplitude:float
			match listen_mode:
				ListenMode.position:
					listen_amplitude = (caller_position - listener.global_position).length()
				ListenMode.node2D:
					listen_amplitude = (caller_node.global_position - listener.global_position).length()
			var listen_multi = clamp(range_lerp(listen_amplitude, listen_amplitude_min, listen_amplitude_max, 1, 0), 0, 1)
			offset *= listen_multi
		
		if duration > 0:
			t_raw = move_toward(t_raw, 0, delta / duration)
	elif hold_t > 0:
		hold_t -= delta
	return offset

func update_offset(delta):
	_update_offset(delta)
	
	if amplitude_curve != 0:
		angle *= ease(t, amplitude_curve)
		offset *= ease(t, amplitude_curve)
		zoom *= ease(t, amplitude_curve)
	
	if boost_t > 0:
		offset *= boost_multi
		boost_t -= delta

func _update_offset(delta):
	pass

# holds the shake for a certain duration, good for building kinetic tension
func hold(duration:float, calculate_initial:bool = false)->CameraShake:
	hold_t = duration
	if calculate_initial:
		process(.0001, true)
	return self

func skip(duration:float):
	t -= duration / self.duration

# multiplies the shake for a certain duration, good for adding an extra kick at the start of the shake
func boost(duration:float, multiplier:float = 3)->CameraShake:
	boost_t = duration
	boost_multi = multiplier
	return self

func from_position(position:Vector2, amplitude_max = 500, amplitude_min = 0, listener:Node2D = null)->CameraShake:
	self.caller_position = position
	listen_mode = ListenMode.position
	listen_amplitude_min = amplitude_min
	listen_amplitude_max = amplitude_max
	if listener: self.listener = listener
	return self

func from_node(node, amplitude_max, amplitude_min, listener:Node2D = null)->CameraShake:
	caller_node = node
	listen_amplitude_min = amplitude_min
	listen_amplitude_max = amplitude_max
	listen_mode = ListenMode.node2D
	if listener: self.listener = listener
	return self

func from_global()->CameraShake:
	listen_mode = ListenMode.global
	return self

func amplitude_in(value:float = 0)->CameraShake:
	amplitude_curve = 1 / value
	return self

func amplitude_out(value:float = 0)->CameraShake:
	amplitude_curve = 1 + value
	return self

func amplitude_inout(value:float = 0)->CameraShake:
	amplitude_curve = -(1 + value)
	return self

func amplitude_constant()->CameraShake:
	amplitude_curve = 0
	return self

func frequency_in(value:float = 0)->CameraShake:
	frequency_curve = 1 / value
	return self

func frequency_out(value:float = 0)->CameraShake:
	frequency_curve = 1 + value
	return self

func frequency_inout(value:float = 0)->CameraShake:
	frequency_curve = -(1 + value)
	return self

func frequency_constant()->CameraShake:
	return self

func limit_fps(fps)->CameraShake:
	self.fps = fps
	return self

func reverse()->CameraShake:
	reversed = !reversed
	return self

func pause()->CameraShake:
	playing = false
	return self

func play()->CameraShake:
	playing = true
	return self

func stop():
	t = 0

func clean():
	listener = null
	caller_node = null
