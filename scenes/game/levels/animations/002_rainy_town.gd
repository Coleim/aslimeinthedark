extends Node2D

signal ended

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
	camera.position_smoothing_speed = 0.5
	camera.limit_top = -600
	$FlashTimer.connect("timeout", _playFlash)
	$FlashTimer.set_wait_time(5)
	$FlashTimer.start()
	$HideFlashTimer.connect("timeout", _hideFlash)
	$HideFlashTimer.set_wait_time(0.2)
	$ThunderTimer.connect("timeout", _playThunder)
	$ThunderTimer.set_wait_time(0.1)
	
	var velocity = Vector2()
	velocity.y -= 1
	velocity = velocity * 50
	camera.position += velocity
	
	$Rain.material.set_shader_parameter("rain_amount", 500)
	$Rain.material.set_shader_parameter("near_rain_length", 0.083)
	$Rain.material.set_shader_parameter("far_rain_length", 0.1)
	$Rain.material.set_shader_parameter("near_rain_width", 0.141)
	$Rain.material.set_shader_parameter("far_rain_width", 0.429)
	$Rain.material.set_shader_parameter("near_rain_transparency", 0.783)
	$Rain.material.set_shader_parameter("far_rain_transparency", 0.5)
	$Rain.material.set_shader_parameter("rain_color", Color("#cccccc"))
	$Rain.material.set_shader_parameter("base_rain_speed", 0.5)
	$Rain.material.set_shader_parameter("additional_rain_speed", 0.5)
	$Rain.material.set_shader_parameter("hint_range", 0.2)

func _process(delta):
	var camera = $Camera2D
	var velocity = Vector2()
	velocity.y -= 1
	velocity = velocity * 50
	camera.position += velocity * delta

func _hideFlash():
	$CanvasModulate.show()
	$HideFlashTimer.stop()
	$ThunderTimer.set_wait_time(0.2)
	$ThunderTimer.start()
	
func _playFlash():
	if count > 2:
		# ended.emit()
		get_tree().quit()
	else:
		$CanvasModulate.hide()
		$FlashTimer.stop()
		$HideFlashTimer.start()

func _playThunder():
	$ThunderTimer.stop()
	if count == 0:
		$ThunderSoundEffect_03.play()
		#$ThunderSoundEffect_02.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000,5)
		$FlashTimer.set_wait_time(1)
		$FlashTimer.start()
	if count == 1:
		$ThunderSoundEffect_01.play()
		$ThunderSoundEffect_01.connect("finished", _playFlash)
		$Camera2D.shake(1, 1000, 3)
	if count == 2:
		$ThunderSoundEffect_02.play()
		$Camera2D.shake(1, 1000, 4)
		$FlashTimer.set_wait_time(2)
		$FlashTimer.start()
	count += 1

