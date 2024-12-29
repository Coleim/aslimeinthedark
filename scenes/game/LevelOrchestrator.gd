extends Node2D

const _001_rainy_town = preload("res://scenes/game/levels/animations/001_rainy_town.tscn")
const _002_rainy_town = preload("res://scenes/game/levels/animations/002_rainy_town.tscn")
const _003_cuve = preload("res://scenes/game/levels/animations/003_cuve.tscn")
const _001_001 = preload("res://scenes/game/levels/001/001_001.tscn")
const _001_001_music = preload("res://assets/audio/001_001_loop.mp3")


var current_level_index = 0;
var current_player: AudioStreamPlayer

const level_list = [
	[ _001_rainy_town, null ],
	[ _002_rainy_town, null ],
	[ _003_cuve, null ],
	[ _001_001, _001_001_music ],
]

func getCurrentScene():
	if current_level_index > level_list.size() :
		current_level_index = 0
	return level_list[current_level_index][0].instantiate()
	
func playMusic(audio_player: AudioStreamPlayer):
	print(" playMusic ")
	current_player = audio_player
	if current_level_index > level_list.size() :
		current_level_index = 0
	if level_list[current_level_index][1] != null:
		print( level_list[current_level_index][1] )
		current_player.stream = level_list[current_level_index][1]
		current_player.play()
		audio_player.connect("finished", _on_music_finished)
	
func stopMusic():
	if current_player:
		current_player.stop()

func _on_music_finished():
	current_player.play()
	current_player.connect("finished", _on_music_finished)
	
func getNextScene():
	current_level_index += 1
	return getCurrentScene()

