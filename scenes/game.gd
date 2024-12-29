extends Node2D

const main_screen = preload("res://scenes/menu/main_screen.tscn")

const start_level_at = 3

func setupMainScreen():
	var main_screen_instance = main_screen.instantiate()
	main_screen_instance.connect("startGame", _startGame)
	$Menu.add_child(main_screen_instance)

func _ready():
	setupMainScreen()
	
func _startGame():
	for n in $Menu.get_children():
		$Menu.remove_child(n)
		n.queue_free()
	$LevelOrchestrator.current_level_index = start_level_at
	var level = $LevelOrchestrator.getCurrentScene()
	level.connect("scened_ended", _on_scene_ends)
	level.connect("start_music", _on_start_music)
	level.connect("stop_music", _on_stop_music)
	$Level.add_child(level)

func _on_scene_ends():
	for n in $Level.get_children():
		$Level.remove_child(n)
		n.queue_free()
	var level = $LevelOrchestrator.getNextScene()
	level.connect("scened_ended", _on_scene_ends)
	$Level.add_child(level)

func _on_start_music():
	$LevelOrchestrator.playMusic($MusicPlayer)

func _on_stop_music():
	$LevelOrchestrator.stopMusic()
	
