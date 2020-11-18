# QuakeCam2D

A versatile and easy to use camera shake plugin for Godot

# How to use

```
QuakeCam2D.shake_quake()
```

You can store a shake to keep control over it while it's in effect
```
var shake = QuakeCam2D.shake_quake(-1)

func press_pause():
  shake.pause()

func press_play():
  shake.play()
```

You can chain functions to add special behaviors to the shake
```
QuakeCam2D.shake_quake().boost().hold(.1).reverse()
```

```boost(duration:float, multiplier:float = 3)```
Multiplies the shake for a certain duration, good for adding an extra kick at the start of the shake

```hold(duration:float, calculate_initial:bool = false)```
Waits a certain duration before executing the shake, good for building kinetic tension
use calculate_initial to jump to the first offset of the shake and hold it there

```reverse()```
Will make the shake start at 0 and build up over time

```limit_fps(fps:float)```
Will make the shake play at a certain FPS

```skip(duration:float)```
Skips part of the shake


## Fading
You can setup how you want a shake to fade out. The shake fades out in it's amplitude and frequency, unless it's set to constant. 
```QuakeCam2D.shake_quake().amplitude_in(1).frequency_constant()```

## Caller/Listener
Sometimes you want a shake to come from a specific location. IE. you might want moving platforms to hit walls and set the camera shaking but only when the player is near. This can be set up easily:
```
QuakeCam2D.shake_quake().from_node(platform, 500, 100, 1, player)
```

You can set the default listener in the QuakeCam2D node so you don't have to define one each time. The default default is the camera itself. 
```QuakeCam2d.default_listener = player```

```from_node(node:Node2D, amplitude_max:float, amplitude_min:float, listener:Node2D, falloff_curve:float)```
Will play the shapes intensity based on the distance between the listener and caller node. This is useful for moving objects where the distance keeps changing.

```from_node(position:Vector2, amplitude_max:float, amplitude_min:float, listener:Node2D, falloff_curve:float)```
Will play the shapes intensity based on the distance between the listener and call position.

# Custom shakes
You can make your own shake script by extending the CameraShake class
All you really need to include in this class is a _update_offset() function in which you set the offset variable. An _init() function where you at least set up the duration and amplitude is adviced to give more control over the shake.
```
extends CameraShake
class_name CameraShakeShock

func _init(duration:float, amplitude:float):
	init(duration, amplitude)

func _update_offset(delta):
	offset = Vector2.RIGHT.rotated(randf() * TAU) * amplitude * randf()
```
Note that in the _update_offset() function you have to set up the behavior for the shake at it's maximum intensity.
The delta and final offset get automatically multiplied by the time left, so the shake will fade out. If you don't want a shake to fade out you can call amplitude_constant() and frequency_constant() in the _init() function.
