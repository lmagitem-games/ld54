extends Camera2D

# Speed of the camera movement in pixels per second.
@export var speed: float = 400.0
@export var smooth_factor: float = 0.1

@export var top_left_border: Vector2 = Vector2(0, 0)
@export var bottom_right_border: Vector2 = Vector2(1000, 1000)

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
