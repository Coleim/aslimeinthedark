extends Control


@export var disket_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$DisketCount.hide()
	$DisketIcon.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if disket_count != 0:
		$DisketCount.text = '[right]' + str(disket_count) + '[/right]'
		$DisketCount.show()
		$DisketIcon.show()
