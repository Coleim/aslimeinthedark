extends Node2D

func _ready():
	var exitBtn = $MarginContainer2/MarginContainer/HBoxContainer/VBoxContainer/Exit_button
	exitBtn.connect("pressed", _on_exit_pressed)

func _on_exit_pressed():
	get_tree().quit()
