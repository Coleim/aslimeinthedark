extends Node2D

signal scened_ended
signal start_music

@onready var camera: Camera2D = $PlayerFollowCamera
var level_limit_left = -240
var level_limit_right = 1472

func _ready():
	$IntroMusic.play()
	$IntroMusic.connect("finished", _on_intro_finished)
	$Player.follow_camera = camera
	$Player.viewport_size = get_viewport_rect().size
	camera.player_position = $Player.position
	camera.level_limit_left = level_limit_left
	camera.level_limit_right = level_limit_right

func _process(delta):
	camera.player_position = $Player.position
	$Player.viewport_size = get_viewport_rect().size

func _on_intro_finished():
	start_music.emit()
	
