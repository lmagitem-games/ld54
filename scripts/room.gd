extends Node2D

const RoomEnums = preload("res://scripts/room-enums.gd")

@export var room_type: RoomEnums.RoomType
@export var room_plan: RoomEnums.RoomPlan
@export var room_rotation: RoomEnums.RoomRotation
@export var grid_size = Vector2(16, 16)
@export var rotation_cooldown: int = 10
var current_tilemap: TileMap = null
var is_placing := false
var last_rotation_time: int = 0

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

func _process(delta):
	if is_placing:
		var mouse_position = get_global_mouse_position()
		var grid_x = int(mouse_position.x / grid_size.x) * grid_size.x
		var grid_y = int(mouse_position.y / grid_size.y) * grid_size.y
		global_position = Vector2(grid_x, grid_y)
		
func _input(event):
	print(self.name)
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
				else:
					is_placing = false
					set_process(false)

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

func _build_tilemap_name() -> String:
	var type_string
	match room_type:
		RoomEnums.RoomType.SHELTER: type_string = "Shelter"
		RoomEnums.RoomType.ENERGY: type_string = "Energy"
		RoomEnums.RoomType.FOOD: type_string = "Food"
		RoomEnums.RoomType.LIFE_SUPPORT: type_string = "LifeSupport"
		
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
	print(next_rotation)
	set_room_rotation(next_rotation)

func set_previous_rotation():
	var previous_rotation = (room_rotation - 1 + RoomEnums.RoomRotation.size()) % RoomEnums.RoomRotation.size()
	set_room_rotation(previous_rotation)
