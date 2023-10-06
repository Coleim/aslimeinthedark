extends Node2D

var decay = 0.8  # How quickly the shaking stops [0, 1].
var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var target

var random = RandomNumberGenerator.new()
var trauma = 1.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

var count = 0

func _ready():
	var camera = $Camera2D
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 0.1
	camera.limit_left = 0
	$FlashTimer.connect("timeout", _playFlash)
	$FlashTimer.set_wait_time(0)
	$FlashTimer.start()
	$HideFlashTimer.connect("timeout", _hideFlash)
	$HideFlashTimer.set_wait_time(0.2)
	$ThunderTimer.connect("timeout", _playThunder)
	$ThunderTimer.set_wait_time(0.1)
	
	var velocity = Vector2()
	velocity.x -= 1
	velocity = velocity * 50
	camera.position += velocity

func _process(delta):
	var camera = $Camera2D
	var velocity = Vector2()
	velocity.x -= 1
	velocity = velocity * 50
	camera.position += velocity * delta

func _hideFlash():
	$CanvasModulate.show()
	$HideFlashTimer.stop()
	$ThunderTimer.set_wait_time(0.2)
	$ThunderTimer.start()
	
func _playFlash():
	if count > 3:
		print("STOP !!")
	else:
		$CanvasModulate.hide()
		$FlashTimer.stop()
		$HideFlashTimer.start()

func _playThunder():
	$ThunderTimer.stop()
	if count == 0:
		$ThunderSoundEffect_02.play()
		$ThunderSoundEffect_02.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000,5)
	if count == 1:
		$ThunderSoundEffect_01.play()
		$ThunderSoundEffect_01.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000, 3)
	if count == 2:
		$ThunderSoundEffect_03.play()
		$ThunderSoundEffect_03.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000, 4)
	if count == 3:
		$ThunderSoundEffect_01.play()
		$ThunderSoundEffect_01.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000, 3)
	count += 1

'''
func _ready():
	var camera = $Camera2D
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 0.1
	camera.limit_left = 0
	$ThunderSoundEffect.play()
	$ThunderSoundEffect.connect("finished", _thunderDone)
	$FlashTimer.connect("timeout", _playFlash)
	$FlashTimer.set_wait_time(0)
	$FlashTimer.start()
	$HideFlashTimer.connect("timeout", _hideFlash)
	$HideFlashTimer.set_wait_time(0.2)

func _process(delta):
	var camera = $Camera2D
	var velocity = Vector2()
	velocity.x -= 1
	velocity = velocity * 50
	camera.position += velocity * delta
	

	
func _thunderDone():
	print("END SCENE")

func _playFlash():
	print("_playFlash")
	$Camera2D.shake(1, 1000, 2)
	# shake(duration, frequency, amplitude)
	$FlashTimer.stop()
	$FlashTimer.set_wait_time(9)
	$FlashTimer.start()
	#$FlashTimer.set_wait_time(random.randf_range(2, 6))
	#$FlashTimer.stop()
	$CanvasModulate.hide()
	$HideFlashTimer.start()
	
'''
