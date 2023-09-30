extends MenuButton

const RoomEnums = preload("res://scripts/room-enums.gd")

@export var room_type: RoomEnums.RoomType
@export var room_plans: Array[RoomEnums.RoomPlan]
@export var room_rotation: RoomEnums.RoomRotation

var room_scene = preload("res://scenes/room.tscn")

func _ready():
	self.get_popup().connect("id_pressed", self._on_menu_item_pressed)

func _on_menu_item_pressed(id):
	var room_plan = room_plans[id]
	var room_instance = room_scene.instantiate()
	get_tree().root.add_child(room_instance)
	room_instance.set_room_type(room_type)
	room_instance.set_room_plan(room_plan)
	room_instance.set_room_rotation(room_rotation)
	room_instance.start_placing()
