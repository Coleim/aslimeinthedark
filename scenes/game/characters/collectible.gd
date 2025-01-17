extends StaticBody2D

# Adjust these to control the pulsating effect
var min_energy: float = 0.5
var max_energy: float = 2.0
var speed: float = 0.5

func _process(_delta):
	if $Light:
		$Light.energy = lerp(min_energy, max_energy, (sin(2.0 * PI * speed * Time.get_ticks_msec() / 1000.0) + 1.0) / 2.0)
