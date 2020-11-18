# QuakeCam2D

A versatile and easy to use camera shake plugin for Godot

# How to use

``` python
QuakeCam2D.shake_quake()
```

You can store a shake to keep control over it while it's in effect
``` python
var shake = QuakeCam2D.shake_quake(-1)

func press_pause():
  shake.pause()

func press_play():
  shake.play()
```

#### Special behavior methods

You can chain functions to add special behaviors to the shake
``` python
QuakeCam2D.shake_quake().boost().hold().reverse().boost()
```

``` python
boost(duration:float, multiplier:float = 3)
# Multiplies the shake for a certain duration, good for adding an extra kick at the start of the shake

hold(duration:float, calculate_initial:bool = false)
# Waits a certain duration before executing the shake, good for building kinetic tension
# use calculate_initial to jump to the first offset of the shake and hold it there

reverse()
# Will make the shake start at 0 and build up over time

limit_fps(fps:float)
# Will make the shake play at a certain FPS

skip(duration:float)
# Skips part of the shake
```

### Fading
You can setup how you want a shake to fade out. The shake fades out in it's amplitude and frequency, unless it's set to constant. 
``` python
QuakeCam2D.shake_quake().amplitude_in(1).frequency_constant()
```
These are the functions to define the curve for frequency and amplitude:

``` python
amplitude_in()
amplitude_out()
amplitude_inout()
amplitude_constant()

frequency_in()
frequency_out()
frequency_inout()
frequency_constant()
```


### Caller/Listener
Sometimes you want a shake to come from a specific location. i.e. you might want moving platforms to hit walls and set the camera shaking but only when the player is near. This can be set up easily:
``` python
QuakeCam2D.shake_quake().from_node(platform, 500, 100, 1, player)
```

``` python
from_node(node:Node2D, amplitude_max:float, amplitude_min:float, listener:Node2D, falloff_curve:float)
# Will play the shapes intensity based on the distance between the listener and caller node.
# this is useful for moving objects where the distance keeps changing.

from_node(position:Vector2, amplitude_max:float, amplitude_min:float, listener:Node2D, falloff_curve:float)
# Will play the shapes intensity based on the distance between the listener and call position.
```

You can set the default listener in the QuakeCam2D node so you don't have to define one each time. The default default is the camera itself. 
``` python
QuakeCam2d.default_listener = player
```

## Shakes
### Positional shakes

``` python
shake_quake(duration:float = 1, amplitude:float = 10, frequency:float = 20, randomness:float = 1)
```
Shakes around smoothly

``` python
shake_rumble(duration:float = .5, amplitude:float = 10, frequency:float = 5, direction:int = 0)
```
Circles the camera position around the center

``` python
shake_buzz(duration = .5, amplitude = 10)
```
A vicious random shake that makes sure the camera moves almost the whole amplitude each frame

``` python
shake_shock(duration:float = .3, amplitude:float = 7)
```
The most basic of all. Sets a random direction and amplitude each frame

##### Directional
``` python
shake_pull(duration:float = .5, amplitude:float = 10, direction:float = -1.570796)
```
Moves the camera in a direction and smoothly tweens it back
*tip: the easing can be controlled by setting the amplitude curve ie.* ```amplitude_in(1), amplitude_out(1.5)```

``` python
shake_wave(duration:float = .5, amplitude:float = 10, frequency:float = 5, direction:float = -1.570796)
```
Waves back and forth in a certain direction

``` python
shake_tremble(duration:float = .5, amplitude:float = 10, direction:float = -1.570796)
```
Moves the camera back and forth the whole amplitude each frame
*tip: best used with a limited frame rate, to set the framerate use* ```camera.shake_tramble().limit_fps(12)```

### Rotational shakes
``` python
func shake_bobble(duration:float = .5, amplitude:float = 3, frequency:float = 4, start_angle:float = 0, direction:int = 0)
```
Wobbles the camera angle back and forth around the center like a polite indian

``` python
shake_wobble(duration:float = .5, amplitude:float = 3, frequency:float = 4, direction:int = 0)
```
Similar to bobble but more random

``` python
shake_handheld(duration:float = 1, amplitude:float = 10, speed:float = 1)
```
Moves the camera around randomly similar to a camera being held in hand
*tip: works well if you set it to ongoing (duration to -1) and store the shake as a variables so you can pause() and play() it*

### Zoom shakes
``` python
shake_flinch(duration:float = .2, amplitude:float = .02, direction:int = 1)
```

## Custom shakes
You can make your own shake script by extending the CameraShake class
All you really need to include in this class is a _update_offset() function in which you set the offset variable. An _init() function where you at least set up the duration and amplitude is adviced to give more control over the shake.
``` python
extends CameraShake
class_name CameraShakeShock

func _init(duration:float, amplitude:float):
	init(duration, amplitude)

func _update_offset(delta):
	offset = Vector2.RIGHT.rotated(randf() * TAU) * amplitude * randf()
```
Note that in the _update_offset() function you have to set up the behavior for the shake at it's maximum intensity.
The delta and final offset get automatically multiplied by the time left, so the shake will fade out. If you don't want a shake to fade out you can call amplitude_constant() and frequency_constant() in the _init() function.

Then you can activate the shake by called
``` python
QuakeCam2D.add_shake(my_custom_shake)
```
