extends Node2D

var score = 0

var total_levels = 3 
var levels_state = []

var can_jump = false



func set_score(score):
	var level = {}
	level.score = score
	levels_state.push(level)
	print("level: " , level)
	print("level.score: " , level.score)
	print("levels_state: " , levels_state)
