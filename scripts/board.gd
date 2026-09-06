extends Node2D

const GRID_SIZE := 8
const CELL_SIZE := 80.0

var cells: Dictionary = {}


func _ready() -> void:
	create_board()
	queue_redraw()


func create_board() -> void:
	cells.clear()

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell_pos := Vector2i(x, y)
			cells[cell_pos] = true


func _draw() -> void:
	var viewport_size := get_viewport_rect().size

	# Center the entire 8x8 board
	var board_size := GRID_SIZE * CELL_SIZE
	var offset := (viewport_size - Vector2(board_size, board_size)) / 2.0

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):

			var pos := offset + Vector2(
				x * CELL_SIZE,
				y * CELL_SIZE
			)

			var outer := Rect2(
				pos,
				Vector2(CELL_SIZE, CELL_SIZE)
			)

			var inner := Rect2(
				pos + Vector2(3, 3),
				Vector2(CELL_SIZE - 6, CELL_SIZE - 6)
			)

			# Dark gap
			draw_rect(
				outer,
				Color("#0b111a")
			)

			# Main tile
			draw_rect(
				inner,
				Color("#253342")
			)

			# Inner surface
			draw_rect(
				Rect2(
					pos + Vector2(6, 6),
					Vector2(CELL_SIZE - 12, CELL_SIZE - 12)
				),
				Color("#2b3b4c")
			)

			# Top highlight
			draw_line(
				pos + Vector2(6, 6),
				pos + Vector2(CELL_SIZE - 6, 6),
				Color("#607589"),
				2.0
			)

			# Left highlight
			draw_line(
				pos + Vector2(6, 6),
				pos + Vector2(6, CELL_SIZE - 6),
				Color("#52687c"),
				2.0
			)

			# Bottom shadow
			draw_line(
				pos + Vector2(6, CELL_SIZE - 6),
				pos + Vector2(CELL_SIZE - 6, CELL_SIZE - 6),
				Color("#111b26"),
				2.0
			)

			# Right shadow
			draw_line(
				pos + Vector2(CELL_SIZE - 6, 6),
				pos + Vector2(CELL_SIZE - 6, CELL_SIZE - 6),
				Color("#111b26"),
				2.0
			)


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
	var viewport_size := get_viewport_rect().size
	var board_size := GRID_SIZE * CELL_SIZE

	# Same offset used when drawing
	var offset := (viewport_size - Vector2(board_size, board_size)) / 2.0

	var local_position := screen_position - offset

	return Vector2i(
		floori(local_position.x / CELL_SIZE),
		floori(local_position.y / CELL_SIZE)
	)
