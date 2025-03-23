extends Camera2D

@export var player_position: Vector2
@export var level_limit_left = 0
@export var level_limit_right = 0

func _process(_delta):
	print( "player_position.x: " , player_position.x )
	print( "level_limit_left: " , level_limit_left )
	if player_position.x > level_limit_left && player_position.x < level_limit_right :
		position.x = player_position.x
