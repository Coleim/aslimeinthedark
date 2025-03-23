extends CharacterBody2D

signal object_collected
signal poweritem_collected

@export var level_limit_left = 0

@export var run_speed: int = 250

@export var jump_speed = -800  # Était -600
@export var gravity = 2200  # Était 1200, rend la montée plus rapide
@export var fall_gravity = 3000  # Était 2400, réduit la lourdeur de la descente
@export var jump_sustain = -1000  # Était -500, réduit la prolongation du saut

@export var viewport_size: Vector2 
@export var follow_camera: Camera2D

@export var collected_objects: int = 0
@export var playing = false

@onready var Tdrips =  get_node("Drips")

var previousCollision
var infectedTiles = {}
var can_jump = false
var heading_right = true

func reset():
	previousCollision = null
	infectedTiles = {}

func _ready():
	pass

func get_input(delta):
	velocity.x = 0
	velocity.x = Input.get_axis("ui_left", "ui_right")*run_speed
	
	# Gérer le buffer de saut
	if Input.is_action_just_pressed("ui_accept")  and can_jump and is_on_floor():
		$JumpSound.play()
		velocity.y = jump_speed
	
	# Jump sustain : prolonger le saut si la touche est maintenue
	if Input.is_action_pressed("ui_accept") and velocity.y < 0:
		velocity.y += jump_sustain * delta

func play_animations():
	if velocity.x > 0:
		$AnimatedSprite2D.play("move_right")
		heading_right = true
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move_right")
		$AnimatedSprite2D.flip_h = true
		heading_right = false		
	else:
		$AnimatedSprite2D.play("static")

	if velocity.y != 0:
		$AnimatedSprite2D.play("jump")
		if heading_right:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

func _physics_process(delta):
	if !playing:
		return 
	get_input(delta)
	
	
	#if !is_on_floor():
	#	velocity.y += gravity * delta
		
	# Appliquer la gravité plus forte si on tombe
	if velocity.y > 0:
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	
	move_and_slide()
	play_animations()
	
	#print( "Position 002 : " , position)
	if follow_camera:
		var camera_size = get_viewport_rect().size * follow_camera.zoom
		var camera_rect = Rect2(follow_camera.get_screen_center_position() - camera_size / 2, camera_size)
		position.x = clamp(position.x, camera_rect.position.x + 55, camera_rect.size.x+camera_rect.position.x - 55)
	#print( "Position 002 : " , position)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print( "collision : " , collision.get_collider())
		if collision.get_collider() is StaticBody2D :
			if collision.get_collider().get_meta("type") == "collectible":
				collected_objects = collected_objects + 1
				collision.get_collider().queue_free()
				object_collected.emit(collected_objects)
			if collision.get_collider().get_meta("type") == "power_item":
				var power_item_type = collision.get_collider().get_meta("power_item")
				if power_item_type == "jump":
					can_jump = true
				poweritem_collected.emit(power_item_type)
				collision.get_collider().queue_free()
		
		if is_on_floor() and collision.get_collider() is TileMap and collision.get_normal() == Vector2(0, -1):
			var tilemap = collision.get_collider() as TileMap
			var tile_pos = tilemap.local_to_map(tilemap.to_local (position) )
			var tile_id = tilemap.get_cell_source_id(0, tile_pos)
			if tile_id != -1 and tile_pos != previousCollision:
				previousCollision = tile_pos
				if !infectedTiles.has(tile_pos):
					#var tile_center_pos = tilemap.to_global(tilemap.map_to_local(tile_pos)) + Vector2(10, 32)
					var tile_center_pos = tilemap.to_global(tilemap.map_to_local(tile_pos)) + Vector2(0, 10)
					var drip = Tdrips.duplicate()  as AnimatedSprite2D
					drip.position = tile_center_pos
					var frame_count = drip.sprite_frames.get_frame_count(drip.animation)
					drip.frame = randi_range(0, frame_count)
					drip.show()
					get_parent().get_node("DripsContainer").add_child(drip)
					infectedTiles[tile_pos] = "ON"

