extends Node2D

signal scened_ended
signal start_music
signal stop_music

@onready var player_start_position: Vector2 = $player_start.position 

const disket_total = 1
const tiles_total = 31

var limit_left = -240
var limit_right = 1472

func _ready():
	player_start_position = $player_start.position 
	$Exit.connect("body_entered", _on_exit_reached)
	$Exit/CollisionShape2D.disabled = false
	$IntroMusic.play()
	$IntroMusic.connect("finished", _on_intro_finished)

func _on_intro_finished():
	start_music.emit()


func _on_exit_reached(body):
	if body.name == 'Player':
		$Exit.disconnect("body_entered", _on_exit_reached)
		$CanvasModulate.color = "5b5b5b"
		$IntroMusic.stop()
		scened_ended.emit()
		
