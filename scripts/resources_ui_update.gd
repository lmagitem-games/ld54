extends HBoxContainer

@export var life_support_icon: TextureRect
@export var life_support_label: Label
@export var food_icon: TextureRect
@export var food_label: Label
@export var energy_icon: TextureRect
@export var energy_label: Label
@export var population_icon: TextureRect
@export var population_label: Label
@export var shelter_icon: TextureRect
@export var shelter_label: Label
@export var happiness_icon: TextureRect
@export var happiness_label: Label
@export var timer_icon: TextureRect
@export var timer_label: Label

func _ready():
	GameManager.connect("life_support_changed", self._on_life_support_changed)
	GameManager.connect("food_changed", self._on_food_changed)
	GameManager.connect("energy_changed", self._on_energy_changed)
	GameManager.connect("population_changed", self._on_population_changed)
	GameManager.connect("shelter_changed", self._on_shelter_changed)
	GameManager.connect("happiness_changed", self._on_happiness_changed)
	GameManager.connect("timer_changed", self._on_timer_changed)
	self._on_life_support_changed()
	self._on_food_changed()
	self._on_energy_changed()
	self._on_population_changed()
	self._on_shelter_changed()
	self._on_happiness_changed()
	self._on_timer_changed()

func _on_life_support_changed():
	life_support_label.text = str(GameManager.life_support)
	_update_icon_color(life_support_icon, GameManager.life_support, GameManager.ideal_life_support)

func _on_food_changed():
	food_label.text = str(GameManager.food)
	_update_icon_color(food_icon, GameManager.food, GameManager.ideal_food)

func _on_energy_changed():
	energy_label.text = str(GameManager.energy)
	_update_icon_color(energy_icon, GameManager.energy, GameManager.ideal_energy)

func _on_population_changed():
	population_label.text = str(GameManager.population)
	_update_icon_color(population_icon, GameManager.population, GameManager.ideal_population)

func _on_shelter_changed():
	shelter_label.text = str(GameManager.shelter)
	_update_icon_color(shelter_icon, GameManager.shelter, GameManager.population * 1.5)

func _on_happiness_changed():
	happiness_label.text = str(GameManager.happiness)
	_update_icon_color(happiness_icon, GameManager.happiness, GameManager.ideal_happiness)

func _on_timer_changed():
	timer_label.text = str(GameManager.timer)
	_update_icon_color(timer_icon, GameManager.timer, GameManager.timer_interval)

func _update_icon_color(icon: TextureRect, value: float, ideal: float):
	var percent = clamp(value / ideal, 0.1, 1)

	var green_color = Color(0, 1, 0, 1)
	var yellow_color = Color(1, 1, 0, 1)
	var red_color = Color(1, 0, 0, 1)

	if percent > 0.4:
		icon.modulate = green_color.lerp(yellow_color, (1 - percent) * (2.5))
	else:
		icon.modulate = yellow_color.lerp(red_color, (0.4 - percent) * (2.5))
