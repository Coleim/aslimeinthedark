extends Node2D

signal startGame

var lightGlowValue = 0.7
var glowingDown = true

func _ready():
	var exitBtn = $MarginContainer2/MarginContainer/HBoxContainer/VBoxContainer/Exit_button
	var startBtn = $MarginContainer2/MarginContainer/HBoxContainer/VBoxContainer/Start_button
	exitBtn.connect("pressed", _on_exit_pressed)
	startBtn.connect("pressed", _on_start_pressed)
	$GlowTimer.start(0.1)
	$TextureRect.modulate = Color(0, 1, 0, lightGlowValue)
	$GlowTimer.connect("timeout", _on_timer_end)
	
	
func _on_timer_end():
	if glowingDown:
		lightGlowValue -= 0.01
	else:
		lightGlowValue += 0.01
	$TextureRect.modulate = Color(0, 1, 0, lightGlowValue)
	if lightGlowValue < 0.3:
		glowingDown = false;
	if lightGlowValue > 0.6:
		glowingDown = true;

func _on_exit_pressed():
	get_tree().quit()
func _on_start_pressed():
	startGame.emit()
