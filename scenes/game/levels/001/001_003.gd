extends Node2D

signal scened_ended
signal start_music

@onready var player_start_position: Vector2 = $player_start.position 

const disket_total = 1
const tiles_total = 27

var limit_left = -695
var limit_right = 804
var _timer = 0.0
var max_spawn_interval = 1.0
var spawn_interval = randf_range(0, max_spawn_interval)

const drips_scene = preload("res://scenes/game/drop_water.tscn")

var base_text = tr("AI_001")

func _ready():
	$IA_Panel.base_text = base_text
	$IA_Panel.update_cursor()
	player_start_position = $player_start.position 
	$Exit.connect("body_entered", _on_exit_reached)
	$Exit/CollisionShape2D.disabled = false

func _process(delta):
	
	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0
		spawn_interval = randf_range(0, max_spawn_interval)
		spawn_faller()
		
func spawn_faller():
	var drop = drips_scene.instantiate()
	drop.position = $LightDrop.position
	var width = $LightDrop.texture.get_width()*2
	drop.position.x = randi_range($LightDrop.position.x-width, $LightDrop.position.x+width)
	add_child(drop)
	drop.show()
	
func _on_exit_reached(body):
	if body.name == 'Player':
		$Exit.disconnect("body_entered", _on_exit_reached)
		$CanvasModulate.color = "5b5b5b"
		scened_ended.emit()
