extends Node

# Define signals
signal life_support_changed
signal food_changed
signal energy_changed
signal population_changed
signal shelter_changed
signal happiness_changed
signal timer_changed

var tile_size := Vector2(16, 16)
var block_size := 3
var life_support:= 36
var ideal_life_support:= 100
var food:= 36
var ideal_food:= 100
var energy:= 36
var ideal_energy:= 100
var population:= 36
var shelter:= 36
var happiness:= 36
var ideal_happiness:= 100
var timer:= 60.0
var timer_interval:= 60.0
var map_tiles = []
var rooms = []

func register_room(room):
	rooms.append(room)
	
func unregister_room(room):
	rooms.erase(room)

func _ready():
	print("GameManager is ready!")
	
func setup_timer(timer_node: Timer):
	timer_node.wait_time = 1
	timer_node.one_shot = false
	timer_node.start()
	timer_node.connect("timeout", self._on_timer_timeout)

func _on_timer_timeout():
	if timer > 0:
		set_timer(timer - 1)
	elif timer == 0:
		set_timer(timer_interval)

func set_life_support(value):
	if life_support != value:
		life_support = value
		emit_signal("life_support_changed")

func set_food(value):
	if food != value:
		food = value
		emit_signal("food_changed")

func set_energy(value):
	if energy != value:
		energy = value
		emit_signal("energy_changed")

func set_population(value):
	if population != value:
		population = value
		emit_signal("population_changed")

func set_shelter(value):
	if shelter != value:
		shelter = value
		emit_signal("shelter_changed")

func set_happiness(value):
	if happiness != value:
		happiness = value
		emit_signal("happiness_changed")

func set_timer(value):
	if timer != value:
		timer = value
		emit_signal("timer_changed")
