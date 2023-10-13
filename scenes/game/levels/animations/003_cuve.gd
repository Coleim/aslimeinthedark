extends Node2D

signal scened_ended

var lightUp = true

func _ready():
	$BipAnimation.play("idle")
	var camera = $Camera2D
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 0.5
	camera.limit_right = 1150
	var velocity = Vector2()
	velocity.x += 1
	velocity = velocity
	camera.position += velocity
	playThunder01()
	$ExplodeAnimation01.hide()
	$ExplodeAnimation02.hide()
	$ExplodeAnimation03.hide()
	
	$EnergyAnimation01.play("lightning")
	$EnergyAnimation02.play("lightning")
	$EnergyAnimation03.play("lightning")
	$EnergyAnimation04.play("lightning")
	$EnergyAnimation05.play("lightning")
	
func _process(delta):
	var camera = $Camera2D
	var velocity = Vector2()
	velocity.x += 1
	velocity = velocity * 300
	camera.position += velocity * delta
	
	if lightUp:
		$CuveLight.energy += 1 * delta/2
		$CuveLightExtended.energy += 2 * delta
	else:
		$CuveLight.energy -= 1 * delta/2
		$CuveLightExtended.energy -= 2 * delta
		
	if $CuveLight.energy >= 1.5:
		lightUp = false
	if $CuveLight.energy < 1:
		lightUp = true

func playThunder01():
	$ThunderSoundEffect_01.play()
	$ThunderSoundEffect_01.connect("finished", playThunder03)
	$CuveLight.energy = 1
	$CuveLightExtended.energy = 1
	
func playThunder03():
	$ThunderSoundEffect_03.play()
	$ThunderSoundEffect_03.connect("finished", playThunder02)
	$CuveLight.energy = 5
	$CuveLightExtended.energy = 5

func playThunder02():
	$ThunderSoundEffect_02.play()
	$BreakingGlassSoundEffect.play()
	$ExplodeAnimation01.show()
	$ExplodeAnimation01.play("default")
	$ExplodeAnimation02.show()
	$ExplodeAnimation02.play("explode")
	$ExplodeAnimation03.show()
	$ExplodeAnimation03.play("explode")
	
	#$BreakingGlassSoundEffect.connect("finished", endScene)
	$CuveLight.energy = 15
	$CuveLightExtended.energy = 15
	$cuve_broken.show()
	$CuveLight.hide()
	$CuveLightExtended.hide()
	$EnergyAnimation01.hide()
	$EnergyAnimation02.hide()
	$EnergyAnimation03.hide()
	$EnergyAnimation04.hide()
	$EnergyAnimation05.hide()
	
	#await $ExplodeAnimation01.animation_finished
	await $ThunderSoundEffect_02.finished
	$cuve_background.hide()
	get_tree().quit()

func endScene():
	$ExplodeAnimation01.stop()
	$ExplodeAnimation01.hide()
	#scened_ended.emit()
	get_tree().quit()
	
