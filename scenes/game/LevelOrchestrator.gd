extends Node2D

const _001_rainy_town = preload("res://scenes/game/levels/animations/001_rainy_town.tscn")
const _002_rainy_town = preload("res://scenes/game/levels/animations/002_rainy_town.tscn")
const _003_cuve = preload("res://scenes/game/levels/animations/003_cuve.tscn")
const _001_001 = preload("res://scenes/game/levels/001/001_001.tscn")
const _001_002 = preload("res://scenes/game/levels/001/001_002.tscn")
const _001_001_music = preload("res://assets/audio/001_001_loop.mp3")
const _001_003 = preload("res://scenes/game/levels/001/001_003.tscn")
const _001_004 = preload("res://scenes/game/levels/001/001_004.tscn")
const _001_005 = preload("res://scenes/game/levels/001/001_005.tscn")

const _001_002_music = preload("res://assets/audio/001_002.mp3")

var current_level_index = 0;
var current_audio_player: AudioStreamPlayer

const level_list = [
	[ _001_rainy_town, null ],
	[ _002_rainy_town, null ],
	[ _003_cuve, null ],
	[ _001_001, _001_001_music ],
	[ _001_002, _001_002_music ],
	[ _001_003, null ],
	[ _001_004, null ],
	[ _001_005, null ],
]

func getCurrentScene():
	if current_level_index > level_list.size() :
		current_level_index = 0
	return level_list[current_level_index][0].instantiate()

func playMusic(audio_player: AudioStreamPlayer):
	current_audio_player = audio_player
	if current_level_index > level_list.size():
		current_level_index = 0
	if level_list[current_level_index][1] != null:
		current_audio_player.stream = level_list[current_level_index][1]
		current_audio_player.play()
		current_audio_player.connect("finished", _on_music_finished)

func _on_music_finished():
	if current_audio_player:
		current_audio_player.play()
	#current_audio_player.connect("finished", _on_music_finished)

func getNextScene():
	current_level_index += 1
	return getCurrentScene()

func is_last_level():
	return current_level_index >= level_list.size() - 1
