extends Node2D

signal restart
signal next
signal totalScoreSignal

var disket_count: float = 0
var disket_total: float = 0

var tiles_count: float = 0
var tiles_total: float = 0

var time = 0 # time in seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	$RestartButton.connect("pressed", _on_restart)
	$NextButton.connect("pressed", _on_next)
	

func reset():
	disket_count = 0
	disket_total = 0
	tiles_count = 0
	tiles_total = 0
	time = 0

func compute_score():
	var disket_ratio: float = disket_count / disket_total if disket_total > 0 else 1
	var tiles_ratio: float = tiles_count / tiles_total if tiles_total > 0 else 1
	
	var exploration_score = tiles_ratio * 7000
	var collection_score = disket_ratio * 3000
	var time_penalty = time * 10

	var total_score = round(exploration_score + collection_score - time_penalty)
	totalScoreSignal.emit(total_score)
	$TotalScore.text = "%04d" % total_score if total_score > 0 else "%04d" % 0

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$DisketScore.text = str(disket_count) + '/' + str(disket_total)
	$TilesScore.text = str(tiles_count) + '/' + str(tiles_total)
	var minutes = round(time / 60)
	var seconds = time - minutes*60
	$TimeScore.text = "%02d" % minutes + ":" +"%02d" % seconds
	compute_score()

func _on_restart():
	restart.emit()

func _on_next():
	next.emit()
	
