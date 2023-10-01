extends AudioStreamPlayer

var opening = false
var fading = false

func _ready():
	stream = load("res://assets/CONSTRUCTION_Digger_Digging_01_loop_stereo.wav")
	volume_db = -80

func _process(delta):
	if opening:
		volume_db += 300 * delta
		if volume_db > -10:
			opening = false
			fading = true
	if fading:
		volume_db -= 8 * delta
		if volume_db <= -70:
			fading = false

func start_building():
	stream = load("res://assets/CONSTRUCTION_Digger_Digging_01_loop_stereo.wav")
	volume_db = -80
	opening = true
	play()

func start_destroying():
	stream = load("res://assets/DEMOLISH_Wood_Metal_stereo.wav")
	volume_db = -80
	opening = true
	play()
	
