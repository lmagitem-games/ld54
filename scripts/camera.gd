extends Camera2D

@export var speed: float = 2000.0
@export var smooth_factor: float = 0.2

@export var top_left_border: Vector2 = Vector2(0, 0)
@export var bottom_right_border: Vector2 = Vector2(3000, 2000)

var dragging = false
var drag_start_pos = Vector2()

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

	if dragging:
		var mouse_motion = drag_start_pos - get_global_mouse_position()
		var target_position = position + mouse_motion
		target_position.x = clamp(target_position.x, top_left_border.x, bottom_right_border.x)
		target_position.y = clamp(target_position.y, top_left_border.y, bottom_right_border.y)
		position = target_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				dragging = true
				drag_start_pos = get_global_mouse_position()
			else:
				dragging = false

	if event is InputEventMouseMotion and dragging:
		drag_start_pos = get_global_mouse_position()
