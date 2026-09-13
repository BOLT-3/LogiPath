extends Node2D

## Level 1 uses the same atlas as the tilemap prototype and is a full 8x8 board.
const GRID_SIZE := 8

const TOP_LEFT := Vector2i(0, 0)
const TOP_EDGE := Vector2i(1, 0)
const TOP_RIGHT := Vector2i(2, 0)
const LEFT_EDGE := Vector2i(0, 1)
const CENTER := Vector2i(1, 1)
const RIGHT_EDGE := Vector2i(2, 1)
const BOTTOM_LEFT := Vector2i(0, 2)
const BOTTOM_EDGE := Vector2i(1, 2)
const BOTTOM_RIGHT := Vector2i(2, 2)


func _enter_tree() -> void:
	var board: TileMapLayer = get_node("TileMap/Board")
	board.clear()

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			board.set_cell(Vector2i(x, y), 0, _atlas_position(x, y))


func _atlas_position(x: int, y: int) -> Vector2i:
	if x == 0 and y == 0:
		return TOP_LEFT
	if x == GRID_SIZE - 1 and y == 0:
		return TOP_RIGHT
	if x == 0 and y == GRID_SIZE - 1:
		return BOTTOM_LEFT
	if x == GRID_SIZE - 1 and y == GRID_SIZE - 1:
		return BOTTOM_RIGHT
	if y == 0:
		return TOP_EDGE
	if y == GRID_SIZE - 1:
		return BOTTOM_EDGE
	if x == 0:
		return LEFT_EDGE
	if x == GRID_SIZE - 1:
		return RIGHT_EDGE
	return CENTER
