extends TileMap

var available_tiles = []

func _ready():
	calculate_available_tiles()

func calculate_available_tiles():
	var used_rect = get_used_rect()
	var start = used_rect.position
	var end = start + used_rect.size
	
	for x in range(int(start.x), int(end.x)):
		for y in range(int(start.y), int(end.y)):
			var cell_pos = Vector2(x, y)
			if is_tile_buildable(cell_pos):
				available_tiles.append(cell_pos)
	
	GameManager.map_tiles = available_tiles

func is_tile_buildable(pos: Vector2) -> bool:
	var tile_id = get_cell_source_id(0, pos)
	if tile_id == -1:
		return false  # Empty tile, not buildable.
	return true
