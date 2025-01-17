extends Node2D

const main_screen = preload("res://scenes/menu/main_screen.tscn")

const start_level_at = 3

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
	$ScoreScreen.connect("next", _next_level)
	$ScoreScreen.connect("restart", _restart_level)
	$Player.connect("object_collected", _on_object_collected)

func _process(_delta):
	if $Player.playing:
		camera.player_position = $Player.position
		$Player.viewport_size = get_viewport_rect().size

func _startGame():
	$ScoreScreen.hide()
	for n in $Menu.get_children():
		$Menu.remove_child(n)
		n.queue_free()
	$LevelOrchestrator.current_level_index = start_level_at
	create_level($LevelOrchestrator.getCurrentScene())


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
	camera.position = camera_start_position
	# Change level
	for n in $Level.get_children():
		$Level.remove_child(n)
		n.queue_free()
	
func _restart_level():
	$Player.position = Vector2(0,0)
	_cleanup_level()
	print( " clean up done ")
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
		
		_on_stop_music()
		$ScoreScreen/EndLevelMusic.play()

func create_level(level):
	current_level = level
	$Level.add_child(level)
	$Player.position = level.player_start_position
	
	level.connect("scened_ended", _on_scene_ends)
	level.connect("start_music", _on_start_music)
	level.connect("stop_music", _on_stop_music)
	
	$Player.follow_camera = camera
	$Player.viewport_size = get_viewport_rect().size
	camera.player_position = $Player.position
	camera.level_limit_left = level.limit_left
	camera.level_limit_right = level.limit_right
	
	$Player.show()
	$PlayerFollowCamera/HUD.show()
	$Player.playing = true
	time_start = Time.get_ticks_msec()

func _on_start_music():
	$LevelOrchestrator.playMusic($MusicPlayer)

func _on_stop_music():
	$MusicPlayer.stop()

func _on_object_collected(disket_count):
	$PickupItemSound.play()
	$PlayerFollowCamera/HUD.disket_count = disket_count

func end_game():
	print("END OF THE GAME")
	setupMainScreen()
