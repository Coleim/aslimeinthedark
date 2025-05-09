extends Node2D

const main_screen = preload("res://scenes/menu/main_screen.tscn")

const start_level_at = 0

@onready var camera: Camera2D = $PlayerFollowCamera
var camera_start_position: Vector2 
var current_level = null
var time_start = 0
var time_now = 0

func setupMainScreen():
	var main_screen_instance = main_screen.instantiate()
	main_screen_instance.connect("startGame", _startGame)
	$Menu.add_child(main_screen_instance)
	camera_start_position = camera.position

func _ready():
	setupMainScreen()
	$PlayerFollowCamera.set_enabled(false)
	$ScoreScreen.connect("next", _next_level)
	$ScoreScreen.connect("restart", _restart_level)
	$Player.connect("object_collected", _on_object_collected)
	$Player.connect("poweritem_collected", _on_poweritem_collected)
	$ScoreScreen.connect("totalScoreSignal", _on_total_score_change)
	# $GameState.init(start_level_at)

func _process(_delta):
	if $Player.playing:
		camera.player_position = $Player.position
		$Player.viewport_size = get_viewport_rect().size

func _on_total_score_change(_score):
	#$GameState.set_score(score)
	pass
	
	
func _startGame():
	$ScoreScreen.hide()
	for n in $Menu.get_children():
		$Menu.remove_child(n)
		n.queue_free()
	$LevelOrchestrator.current_level_index = start_level_at
	create_level($LevelOrchestrator.getCurrentScene())
	#print( "$Player.position 01 : " , $Player.position)


func _cleanup_level():
	$ScoreScreen/EndLevelMusic.stop()
	$Player.reset()
	$ScoreScreen.reset()
	$ScoreScreen.hide()
	
	# Cleanup level
	for n in $DripsContainer.get_children():
		$DripsContainer.remove_child(n)
		n.queue_free()
	$Player.position = camera_start_position
	#print(">>> Cleanup")
	camera.position = camera_start_position
	# Change level
	for n in $Level.get_children():
		$Level.remove_child(n)
		n.queue_free()
	
func _restart_level():
	$Player.position = Vector2(0,0)
	_cleanup_level()
	#print( " clean up done ")
	create_level($LevelOrchestrator.getCurrentScene())

func _next_level():
	_cleanup_level()

	if $LevelOrchestrator.is_last_level():
		end_game()
	else:
		create_level($LevelOrchestrator.getNextScene())
	
func _on_scene_ends():
	if $Player.playing:
		$Player.hide()
		$Player.playing = false
		# Display score
		$ScoreScreen.disket_count = $Player.collected_objects
		$ScoreScreen.tiles_count = $Player.infectedTiles.size()

		$ScoreScreen.disket_total = current_level.disket_total
		$ScoreScreen.tiles_total = current_level.tiles_total	
		time_now = Time.get_ticks_msec() - time_start
		$ScoreScreen.time = time_now / 1000
		$ScoreScreen.show()
		
		$ScoreScreen.position = camera.position
		$Player.position = Vector2(0,0)
	
		$MusicPlayer.set_volume_db(-100)
		$ScoreScreen/EndLevelMusic.play()
	else:
		_next_level()

func create_level(level):
	current_level = level
	level.connect("show_level_text", _on_show_level_text)
	level.connect("scened_ended", _on_scene_ends)
	level.connect("start_music", _on_start_music)
	$Level.add_child(level)
	
	if "player_start_position" in level:
		var tween = create_tween()
		tween.tween_property($MusicPlayer, "volume_db", 0.0, 0.5)  # 0 dB is full volume
		$PlayerFollowCamera.set_enabled(true)
		$PlayerFollowCamera.make_current()
		$Player.position = level.player_start_position
		
		$Player.viewport_size = get_viewport_rect().size
		camera.player_position = $Player.position
		camera.level_limit_left = level.limit_left
		camera.level_limit_right = level.limit_right
		if "limit_bottom" in level:
			camera.level_limit_bottom = level.limit_bottom
		else: 
			camera.level_limit_bottom = 0
		if "limit_top" in level:
			camera.level_limit_top = level.limit_top
		else: 
			camera.level_limit_top = 0
			
		
		$Player.follow_camera = camera
		$PlayerFollowCamera.position.x = $Player.position.x
		
		$Player.show()
		$PlayerFollowCamera/HUD.show()
		$Player.playing = true
		time_start = Time.get_ticks_msec()
	

func _on_start_music():
	$LevelOrchestrator.playMusic($MusicPlayer)

func _on_object_collected(disket_count):
	$PickupItemSound.play()
	$PlayerFollowCamera/HUD.disket_count = disket_count

func _on_poweritem_collected(type):
	var label = $PlayerFollowCamera/PowerText
	if type == 'jump':
		label.text = "Vous pouvez sauter"
	$PickupPowerSound.play()
	label.modulate.a = 0.0
	label.show()
	var tween = create_tween()
	# Fade in
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	await tween.finished

	# Wait before fading out
	await get_tree().create_timer(1.5).timeout

	# Fade out
	tween = create_tween() 
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	await tween.finished


func _on_show_level_text(level):
	$NewLevelSound.play()
	var tween = create_tween()
	# Fade in
	var label = $PlayerFollowCamera/LevelText
	label.modulate.a = 0.0
	label.show()
	label.text = level
	tween.tween_property(label, "modulate:a", 1.0, 1.0)
	await tween.finished  # Wait for the tween to finish

	# Wait before fading out
	await get_tree().create_timer(2.0).timeout
	# Fade out
	tween = create_tween()  # Create a new tween
	tween.tween_property(label, "modulate:a", 0.0, 1.0)  # Over 1 second
	await tween.finished

func end_game():
	print("END OF THE GAME")
	setupMainScreen()
