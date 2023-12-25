extends Node2D

@onready var camera: Camera2D = $PlayerFollowCamera
var level_limit_left = -340
var level_limit_right = 1472

func _ready():
	$Player.follow_camera = camera
	$Player.follow_camera = camera
	$Player.viewport_size = get_viewport_rect().size
	camera.player_position = $Player.position
	camera.level_limit_left = level_limit_left
	camera.level_limit_right = level_limit_right

func _process(delta):
	camera.player_position = $Player.position
	$Player.viewport_size = get_viewport_rect().size

