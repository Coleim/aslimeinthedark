extends Node2D

const main_screen = preload("res://scenes/menu/main_screen.tscn")

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
	var level = $LevelOrchestrator.getFirstScene()
	level.connect("ended", _on_scene_ends)
	$Level.add_child(level)

func _on_scene_ends():
	for n in $Level.get_children():
		$Level.remove_child(n)
		n.queue_free()
	var level = $LevelOrchestrator.getNextScene()
	level.connect("ended", _on_scene_ends)
	$Level.add_child(level)
