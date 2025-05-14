extends Sprite2D

@onready var light = $PointLight2D
var target_energy := 1.0
var speed := 2.0  # Vitesse d'interpolation
var timer := 0.0
var interval := randf_range(0.5, 2.0)

func _process(delta):
	# Interpolation douce vers la cible
	light.energy = lerp(light.energy, target_energy, delta * speed)

	# Quand l'intervalle est passé, on choisit une nouvelle cible
	timer += delta
	if timer >= interval:
		target_energy = randf_range(0.2, 1.5)  # Intensité aléatoire
		interval = randf_range(0.5, 2.0)       # Durée aléatoire entre changements
		timer = 0.0
