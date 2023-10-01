extends Node2D

const RoomEnums = preload("res://scripts/room-enums.gd")

@export var room_type: RoomEnums.RoomType
@export var room_plan: RoomEnums.RoomPlan
@export var room_rotation: RoomEnums.RoomRotation
@export var rotation_cooldown: int = 10
var current_tilemap: TileMap = null
var is_placing := false
var last_rotation_time: int = 0
var room_tiles = []

func set_room_type(value):
	room_type = value
	_update_tilemap()

func set_room_plan(value):
	room_plan = value
	_update_tilemap()

func set_room_rotation(value):
	room_rotation = value
	_update_tilemap()

func start_placing():
	is_placing = true
	set_process(true)

func _ready():
	_update_tilemap()

func _process(delta):
	if is_placing:
		var mouse_position = get_global_mouse_position()
		var block_size_x = GameManager.tile_size.x * GameManager.block_size
		var block_size_y = GameManager.tile_size.y * GameManager.block_size
		var grid_x = int(mouse_position.x / block_size_x) * block_size_x
		var grid_y = int(mouse_position.y / block_size_y) * block_size_y
		
		global_position = Vector2(grid_x, grid_y)
		calculate_available_tiles()
		
		if is_placement_valid():
			modulate = Color(1, 1, 1, 1)
		else:
			modulate = Color(1, 0, 0, 0.5)
			
func is_placement_valid() -> bool:
	if room_tiles.size() == 0:
		return false
	for tile in room_tiles:
		if (is_spacebound_tile(tile) and is_tile_in_spaceship(tile)) or (!is_spacebound_tile(tile) and !is_tile_in_spaceship(tile)) or is_tile_occupied_by_room(tile):
			return false
	return true

func is_tile_in_spaceship(tile: Vector2) -> bool:
	if tile in GameManager.map_tiles:
		return true
	return false

func is_spacebound_tile(pos: Vector2) -> bool:
	if room_type == RoomEnums.RoomType.ENERGY:
		pos = pos - global_position / GameManager.tile_size
		var atlas_coord = current_tilemap.get_cell_atlas_coords(0, pos)
		if atlas_coord == Vector2i(7, 7) or atlas_coord == Vector2i(8, 9) or atlas_coord == Vector2i(8, 17) or atlas_coord == Vector2i(7, 19) or atlas_coord == Vector2i(9, 19) or atlas_coord == Vector2i(12, 19):
			return true
	return false

func is_tile_occupied_by_room(tile: Vector2) -> bool:
	for room in GameManager.rooms:
		if tile in room.room_tiles:
			return true
	return false
		
func _input(event):
	if is_placing:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				var current_time = Time.get_ticks_msec()
				if current_time - last_rotation_time >= rotation_cooldown:
					last_rotation_time = current_time
					if event.button_index == MOUSE_BUTTON_WHEEL_UP:
						set_next_rotation()
					elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
						set_previous_rotation()
			elif event.pressed:
				if event.button_index == MOUSE_BUTTON_RIGHT:
					cancel_placement()
				elif is_placement_valid():
					FXPlayer.start_playing()
					GameManager.register_room(self)
					is_placing = false
					set_process(false)


func _exit_tree():
	GameManager.unregister_room(self)

func cancel_placement():
	if is_placing:
		queue_free()

func _update_tilemap():
	if current_tilemap:
		current_tilemap.visible = false
		
	var tilemap_name = _build_tilemap_name()
	current_tilemap = get_node(tilemap_name)
	name = tilemap_name
	if current_tilemap:
		current_tilemap.visible = true
		
	calculate_available_tiles()

func _build_tilemap_name() -> String:
	var type_string
	match room_type:
		RoomEnums.RoomType.SHELTER: type_string = "Shelter"
		RoomEnums.RoomType.ENERGY: type_string = "Energy"
		RoomEnums.RoomType.FOOD: type_string = "Food"
		RoomEnums.RoomType.LIFE_SUPPORT: type_string = "LifeSupport"
		RoomEnums.RoomType.HAPPINESS: type_string = "Happiness"
		RoomEnums.RoomType.POPULATION: type_string = "Population"
		RoomEnums.RoomType.WORK: type_string = "Work"
		
	var plan_string
	match room_plan:
		RoomEnums.RoomPlan.SQUARE: plan_string = "Square"
		RoomEnums.RoomPlan.Z: plan_string = "Z"
		RoomEnums.RoomPlan.S: plan_string = "S"
		RoomEnums.RoomPlan.LINE: plan_string = "Line"
		RoomEnums.RoomPlan.T: plan_string = "T"
		RoomEnums.RoomPlan.L: plan_string = "L"
		RoomEnums.RoomPlan.INVERTED_L: plan_string = "InvertedL"
	
	var rotation_string
	match room_rotation:
		RoomEnums.RoomRotation.RIGHT: rotation_string = "Right"
		RoomEnums.RoomRotation.DOWN: rotation_string = "Down"
		RoomEnums.RoomRotation.LEFT: rotation_string = "Left"
		RoomEnums.RoomRotation.UP: rotation_string = "Up"
	
	return type_string + plan_string + rotation_string

func set_next_rotation():
	var next_rotation = (room_rotation + 1) % RoomEnums.RoomRotation.size()
	set_room_rotation(next_rotation)

func set_previous_rotation():
	var previous_rotation = (room_rotation - 1 + RoomEnums.RoomRotation.size()) % RoomEnums.RoomRotation.size()
	set_room_rotation(previous_rotation)
	
func calculate_available_tiles():
	if !current_tilemap:
		return
	var used_rect = current_tilemap.get_used_rect()
	var start = global_position / GameManager.tile_size + Vector2(used_rect.position)
	var end = start + Vector2(used_rect.size)
	
	room_tiles.clear()
	for x in range(int(start.x), int(end.x), GameManager.block_size):
		for y in range(int(start.y), int(end.y), GameManager.block_size):
			var block_start_pos = Vector2(x, y)
			if is_tile_filled(block_start_pos):
				room_tiles.append(block_start_pos)

func is_tile_filled(pos: Vector2) -> bool:
	pos = pos - global_position / GameManager.tile_size
	var tile_id = current_tilemap.get_cell_source_id(0, pos)
	var atlas_coord = current_tilemap.get_cell_atlas_coords(0, pos)
	if tile_id == -1:
		return false  # Empty tile, not buildable.
	return true
