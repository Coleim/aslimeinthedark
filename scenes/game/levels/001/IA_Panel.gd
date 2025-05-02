extends Sprite2D

@export var base_text := ""

var cursor_visible = true
var cursor_char = "█"
var blink_timer = 0.0
const BLINK_SPEED = 0.5

func _process(delta):
	blink_timer += delta
	if blink_timer >= BLINK_SPEED:
		blink_timer = 0.0
		cursor_visible = !cursor_visible
		update_cursor()

func update_cursor():
	var label = $AI_Message
	label.text = base_text + (cursor_char if cursor_visible else "")
	
