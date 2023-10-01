extends Node2D

func _ready():
	for child in get_children():
		GameManager.register_room(child)
