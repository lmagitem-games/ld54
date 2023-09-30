extends Node2D

@export var star_count = 200
var screen_size = DisplayServer.window_get_size()
var stars = []

func _ready():
	_generate_stars()
	set_process(true)

func _process(delta):
	for star in stars:
		star.timer -= delta
		if star.timer <= 0:
			star.timer = star.initial_timer
			var flicker = randf_range(0.7, 1.3)
			star.color.a = clamp(star.color.a * flicker, 0.3, 1)
	queue_redraw()

func _draw():
	screen_size = DisplayServer.window_get_size()
	_draw_stars()

func _generate_stars():
	for _i in range(star_count):
		var position = Vector2(randf_range(-1000, screen_size.x + 1000), randf_range(-1000, screen_size.y + 1000))
		var size = randi_range(1, 3)
		var red = randf_range(0.8, 1)
		var green = randf_range(0.8, 1)
		var blue = randf_range(0.8, 1)
		var alpha = randf_range(0.5, 1)
		
		var timer = randf_range(0.1, 0.5)
		var star = {
			"position": position,
			"size": size,
			"color": Color(red, green, blue, alpha),
			"timer": timer,
			"initial_timer": timer  # Store the initial timer value to reset it later
		}
		
		stars.append(star)

func _draw_stars():
	for star in stars:
		draw_rect(Rect2(star.position, Vector2(star.size, star.size)), star.color)
