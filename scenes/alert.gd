extends Control

@onready var happiness_alert = $VBoxContainer/HappinessAlert
@onready var lifesupport_alert = $VBoxContainer/LifeSupportAlert
@onready var food_alert = $VBoxContainer/FoodAlert
@onready var energy_alert = $VBoxContainer/EnergyAlert
@onready var alert_timer = $VBoxContainer/AlertTimer
var game_over = false
var timer_activated = false
var timer = 10

func _ready():
	GameManager.timer_node.connect("timeout", self._on_timer_timeout)

func _on_timer_timeout():
	if timer_activated and !game_over:
		if timer > 0:
			timer -= 1
		elif timer == 0:
			GameManager.game_over.emit()
			game_over = true

func _process(delta):
	if !game_over:
		if GameManager.life_support < 0:
			timer_activated = true
			visible = true
			energy_alert.visible = false
			food_alert.visible = false
			happiness_alert.visible = false
			lifesupport_alert.visible = true
		elif GameManager.energy < 0:
			timer_activated = true
			visible = true
			lifesupport_alert.visible = false
			food_alert.visible = false
			happiness_alert.visible = false
			energy_alert.visible = true
		elif GameManager.food < 0:
			timer_activated = true
			visible = true
			lifesupport_alert.visible = false
			energy_alert.visible = false
			happiness_alert.visible = false
			food_alert.visible = true
		elif GameManager.happiness < 0:
			timer_activated = true
			visible = true
			lifesupport_alert.visible = false
			energy_alert.visible = false
			food_alert.visible = false
			happiness_alert.visible = true
		else:
			timer = 10
			timer_activated = false
			visible = false
			lifesupport_alert.visible = false
			energy_alert.visible = false
			food_alert.visible = false
			happiness_alert.visible = false
		alert_timer.text = str(timer)
