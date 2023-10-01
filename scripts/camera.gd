extends Camera2D

@export var speed: float = 2000.0
@export var smooth_factor: float = 0.2
@export var drag_speed_scale: float = 0.5
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

@export var top_left_border: Vector2 = Vector2(-3000, -2000)
@export var bottom_right_border: Vector2 = Vector2(3000, 2000)

var dragging = false
var drag_start_pos = Vector2()
var original_camera_position = Vector2()

func _process(delta: float) -> void:
	var velocity = Vector2()

	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		var target_position = position + velocity * delta
		target_position.x = clamp(target_position.x, top_left_border.x, bottom_right_border.x)
		target_position.y = clamp(target_position.y, top_left_border.y, bottom_right_border.y)
		position = position.lerp(target_position, smooth_factor)

func _input(event):
	if event is InputEventMouseButton:
		if GameManager.can_zoom and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			var zoom_factor = 1.0
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_factor += zoom_speed  # Zoom In
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_factor -= zoom_speed  # Zoom Out
			
			zoom.x = clamp(zoom.x * zoom_factor, min_zoom, max_zoom)
			zoom.y = clamp(zoom.y * zoom_factor, min_zoom, max_zoom)
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start_pos = get_global_mouse_position()
				original_camera_position = position
				set_process(true) 
			else:
				dragging = false
				set_process(false)
	if dragging and event is InputEventMouseMotion:
		var offset = (drag_start_pos - get_global_mouse_position()) * drag_speed_scale
		var new_position = original_camera_position - offset
		new_position.x = clamp(new_position.x, top_left_border.x, bottom_right_border.x)
		new_position.y = clamp(new_position.y, top_left_border.y, bottom_right_border.y)
		position = new_position
