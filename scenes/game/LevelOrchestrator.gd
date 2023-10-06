extends Node2D

const _001_rainy_town = preload("res://scenes/game/levels/animations/001_rainy_town.tscn")
const _002_rainy_town = preload("res://scenes/game/levels/animations/002_rainy_town.tscn")

var current_level_index = 0;

const level_list = [
	_001_rainy_town,
	_002_rainy_town
]

func getFirstScene():
	return level_list[0].instantiate()

func getNextScene():
	current_level_index += 1
	if current_level_index > level_list.size() :
		current_level_index = 0
	return level_list[current_level_index].instantiate()

