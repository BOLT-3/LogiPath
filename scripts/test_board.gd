extends Node2D


@onready var board: TileMapLayer = $Board
@onready var board_model: BoardModel = $BoardModel
@onready var line: TileMapLayer = $Line


var dragging := false
var path: Array[Vector2i] = []

const LINE_SOURCE_ID := 0


var line_tiles := {
	# One-direction line pieces
	1: Vector2i(2, 2), # UP
	2: Vector2i(1, 2), # RIGHT
	4: Vector2i(4, 2), # DOWN
	8: Vector2i(3, 2), # LEFT

	# Two-direction line pieces
	5: Vector2i(0, 3),  # UP + DOWN
	10: Vector2i(0, 2), # LEFT + RIGHT

	3: Vector2i(1, 3),  # UP + RIGHT
	9: Vector2i(2, 3),  # UP + LEFT
	12: Vector2i(3, 3), # LEFT + DOWN
	6: Vector2i(4, 3),  # DOWN + RIGHT
}


func _ready():
	board_model.build_from_board(board)


func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventScreenTouch:

		if event.pressed:
			dragging = true

			var cell := get_touch_cell(event.position)

			if board_model.get_cell(cell) == null:
				dragging = false
				return

			clear_line_state()
			path = [cell]

			print("pressed ", cell)

		else:
			dragging = false

			print("Path: ", path)
			

			update_path_cells()
			print_path_cells()


	elif event is InputEventScreenDrag and dragging:
		var cell := get_touch_cell(event.position)
		
		if cell != path[-1]:
			add_cell(cell)
			update_path_cells()

func print_path_cells():

	for position in path:

		var cell: LogiCell = board_model.get_cell(position)

		print(
			"Cell ",
			cell.board_position,
			" | line_mask = ",
			cell.line_mask
		)

func get_touch_cell(screen_position) -> Vector2i:
	return board.local_to_map(
		board.to_local(screen_position)
	)


func add_cell(cell_position: Vector2i):
	var previous := path[-1]
	var difference := cell_position - previous

	# Must move exactly one cell horizontally or vertically.
	if abs(difference.x) + abs(difference.y) != 1:
		return

	# Make sure this is an actual board cell.
	var logical_cell: LogiCell = board_model.get_cell(cell_position)

	if logical_cell == null:
		return

	# Moving backwards removes the last cell.
	if path.size() >= 2 and cell_position == path[-2]:
		path.pop_back()
		return

	# Don't allow loops/revisiting cells.
	if cell_position in path:
		return

	path.append(cell_position)


func update_path_cells():
	clear_line_state()

	for i in range(path.size()):

		var position: Vector2i = path[i]
		var cell: LogiCell = board_model.get_cell(position)

		if cell == null:
			continue

		cell.line_color = LogiCell.ColorType.RED
		cell.line_mask = 0


		# Previous cell
		if i > 0:
			var previous: Vector2i = path[i - 1]

			var direction := board_model.get_direction(
				position,
				previous
			)

			cell.line_mask |= direction


		# Next cell
		if i < path.size() - 1:
			var next: Vector2i = path[i + 1]

			var direction := board_model.get_direction(
				position,
				next
			)

			cell.line_mask |= direction


		# Draw the logical state.
		render_line_cell(cell)


func clear_line_state():
	line.clear()

	for cell: LogiCell in board_model.cells_by_position.values():
		cell.line_color = LogiCell.ColorType.NONE
		cell.line_mask = 0


func render_line_cell(cell: LogiCell):
	var position := cell.board_position

	# Nothing to draw.
	if cell.line_color == LogiCell.ColorType.NONE or cell.line_mask == 0:
		line.erase_cell(position)
		return

	var atlas_position = line_tiles.get(cell.line_mask)

	if atlas_position == null:
		print("No line tile for mask: ", cell.line_mask)
		return

	line.set_cell(
		position,
		LINE_SOURCE_ID,
		atlas_position
	)
