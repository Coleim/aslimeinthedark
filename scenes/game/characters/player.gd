extends CharacterBody2D

@export var level_limit_left = 0

@export var run_speed: int = 250
@export var jump_speed = -330
@export var gravity = 600

@export var viewport_size: Vector2 
@export var follow_camera: Camera2D

@onready var Tdrips =  get_node("Drips")

func set_run_speed(nu):
	print("set_run_speed")
	pass

func _ready():
	print("Player READY")
	pass

func get_input():
	velocity.x = 0
	velocity.x = Input.get_axis("ui_left", "ui_right")*run_speed

func play_animations():
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_right")
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("static")
		
var previousCollision
var infectedTiles = {}

func _physics_process(delta):
	get_input()
	if !is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	play_animations()
	
	if follow_camera:
		var camera_size = get_viewport_rect().size * follow_camera.zoom
		var camera_rect = Rect2(follow_camera.get_screen_center_position() - camera_size / 2, camera_size)
		position.x = clamp(position.x, camera_rect.position.x + 55, camera_rect.size.x+camera_rect.position.x - 55)

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if is_on_floor() and collision.get_collider() is TileMap and collision.get_normal() == Vector2(0, -1):
			var tilemap = collision.get_collider() as TileMap
			var tile_pos = tilemap.local_to_map(tilemap.to_local (position) )
			var tile_id = tilemap.get_cell_source_id(0, tile_pos)
			if tile_id != -1 and tile_pos != previousCollision:
				previousCollision = tile_pos
				if !infectedTiles.has(tile_pos):
					var tile_center_pos = tilemap.to_global(tilemap.map_to_local(tile_pos)) + Vector2(10, 32)
					var drip = Tdrips.duplicate()  as AnimatedSprite2D
					drip.position = tile_center_pos
					var frame_count = drip.sprite_frames.get_frame_count(drip.animation)
					drip.frame = randi_range(0, frame_count)
					var cell_alternative_tile = tilemap.get_cell_alternative_tile(0, tile_pos)
					var cell_atlas_coords = tilemap.get_cell_atlas_coords(0, tile_pos)
					var cell_source_id = tilemap.get_cell_source_id(0, tile_pos)
					# TODO: set alternate tile random from 1 to N
					tilemap.set_cell(0, tile_pos, cell_source_id, cell_atlas_coords, 1)
					drip.show()
					get_parent().add_child(drip)
					infectedTiles[tile_pos] = "ON"

