extends Node

const RoomEnums = preload("res://scripts/room-enums.gd")

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

var life_support_gen_per_life_support_tile := 7
var life_support_gen_per_food_tile := 1
var food_gen_per_tile := 12
var energy_gen_per_tile := 5
var shelter_gen_per_tile := 5
var happiness_gen_per_tile := 1

var life_support_cost_per_pop := 1
var food_cost_per_pop := 2
var shelter_cost_per_pop := 1

var life_support_cost_per_food_room := 5
var energy_cost_per_life_support_room := 15
var energy_cost_per_food_room := 5
var energy_cost_per_shelter_room := 3
var energy_cost_per_happiness_room := 3

var happiness_cost_per_homeless := 1
var happiness_cost_per_dead := 3

var life_support:= 0
var ideal_life_support:= 100
var food:= 0
var ideal_food:= 100
var energy:= 0
var ideal_energy:= 100
var population:= 20
var ideal_population:= 0
var shelter:= 0
var happiness:= 100
var ideal_happiness:= 100
var deaths := 0
var timer:= 30.0
var timer_interval:= 30.0

var map_tiles = []
var rooms = []

func _ready():
	update_room_effects()
	
func update_room_effects():
	var life_support = 0
	var food = 0
	var energy = 0
	var shelter = 0
	var happiness = 20
	ideal_population = rooms.size()
	ideal_food = population
	ideal_life_support = population
	for room in rooms:
		match room.room_type:
			RoomEnums.RoomType.SHELTER: 
				shelter += room.room_tiles.size() * shelter_gen_per_tile
				energy -= energy_cost_per_shelter_room
			RoomEnums.RoomType.ENERGY:
				energy += room.room_tiles.size() * energy_gen_per_tile
			RoomEnums.RoomType.FOOD:
				food += room.room_tiles.size() * food_gen_per_tile
				life_support += room.room_tiles.size() * life_support_gen_per_food_tile
				life_support -= life_support_cost_per_food_room
				energy -= energy_cost_per_food_room
			RoomEnums.RoomType.LIFE_SUPPORT:
				life_support += room.room_tiles.size() * life_support_gen_per_life_support_tile
				energy -= energy_cost_per_life_support_room
			RoomEnums.RoomType.HAPPINESS:
				happiness += room.room_tiles.size() * happiness_gen_per_tile
				energy -= energy_cost_per_happiness_room
			RoomEnums.RoomType.POPULATION:
				energy -= energy_cost_per_happiness_room
			RoomEnums.RoomType.WORK:
				energy -= energy_cost_per_happiness_room
	life_support -= population * life_support_cost_per_pop
	food -= population * food_cost_per_pop
	if shelter < population:
		happiness -= population - shelter
	if food < 10:
		happiness -= 10 - food
	if life_support < 10:
		happiness -= 10 - life_support
	set_energy(energy)
	set_food(food)
	set_happiness(happiness)
	set_life_support(life_support)
	set_population(population)
	set_shelter(shelter)

func register_room(room):
	rooms.append(room)
	update_room_effects()
	
func unregister_room(room):
	rooms.erase(room)
	update_room_effects()
	
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
		set_population(population + 10 + floor(population / 10))

func set_life_support(value):
	if life_support != value:
		life_support = value
		update_room_effects()
		emit_signal("energy_changed")
		emit_signal("food_changed")
		emit_signal("life_support_changed")

func set_food(value):
	if food != value:
		food = value
		update_room_effects()
		emit_signal("life_support_changed")
		emit_signal("energy_changed")
		emit_signal("food_changed")

func set_energy(value):
	if energy != value:
		energy = value
		update_room_effects()
		emit_signal("energy_changed")

func set_population(value):
	if population != value:
		population = value
		update_room_effects()
		emit_signal("life_support_changed")
		emit_signal("food_changed")
		emit_signal("shelter_changed")
		emit_signal("happiness_changed")
		emit_signal("population_changed")

func set_shelter(value):
	if shelter != value:
		shelter = value
		update_room_effects()
		emit_signal("energy_changed")
		emit_signal("population_changed")
		emit_signal("shelter_changed")

func set_happiness(value):
	if happiness != value:
		happiness = value
		update_room_effects()
		emit_signal("energy_changed")
		emit_signal("happiness_changed")

func set_timer(value):
	if timer != value:
		timer = value
		emit_signal("timer_changed")
