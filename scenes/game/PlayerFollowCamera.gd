extends Camera2D

@export var player_position: Vector2
@export var level_limit_left = 0
@export var level_limit_right = 0
@export var level_limit_top = 0
@export var level_limit_bottom = 0

func _process(_delta):
	if player_position.x > level_limit_left && player_position.x < level_limit_right :
		position.x = player_position.x
	if player_position.y > level_limit_top && player_position.y < level_limit_bottom :
		position.y = player_position.y
