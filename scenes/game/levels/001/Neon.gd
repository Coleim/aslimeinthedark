extends Sprite2D

@onready var light = $PointLight2D
@onready var sfx = $AudioStreamPlayer


var timer := 0.0
var next_toggle := randf_range(0.1, 0.5) 

func _process(delta):
	timer += delta
	if timer >= next_toggle:
		light.visible = !light.visible
		sfx.play()
		timer = 0.0
		next_toggle = randf_range(0.1, 0.5)
