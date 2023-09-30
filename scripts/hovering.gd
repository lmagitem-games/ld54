extends Node2D

@export var float_speed: float = 1.0  # Speed of the floating movement
@export var float_range: float = 20.0  # Range of the floating movement

var origin_y: float
var time_passed: float = 0.0  # Time passed since the start

func _ready():
	origin_y = position.y

func _process(delta):
	time_passed += delta * float_speed  # Increment the time_passed by the elapsed time multiplied by speed

	var float_offset = cos(time_passed) * float_range  # Calculate the float offset using cosine function for smooth oscillation
	position.y = origin_y + float_offset  # Update the position with the calculated offset

