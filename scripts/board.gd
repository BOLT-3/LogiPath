extends Node2D

const BOARD_SIZE := 8

@onready var tile_map: TileMapLayer = $TileMapLayer

var cells: Dictionary = {}


func _ready() -> void:
	create_board()


func create_board() -> void:
	tile_map.clear()
	cells.clear()

	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var position := Vector2i(x, y)

			cells[position] = Cell.new(position)

			# source_id = 0
			# atlas_coords = (0, 0)
			tile_map.set_cell(position, 0, Vector2i(0, 0))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_press(event.position)

	elif event is InputEventScreenTouch:
		if event.pressed:
			handle_press(event.position)


func handle_press(screen_position: Vector2) -> void:
	var cell_position := screen_to_cell(screen_position)

	if cells.has(cell_position):
		print("Touched cell: ", cell_position)


func screen_to_cell(screen_position: Vector2) -> Vector2i:
	var local_position := tile_map.to_local(screen_position)
	return tile_map.local_to_map(local_position)
