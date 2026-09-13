extends Node2D
class_name BoardModel


var cells: Array = []

var rows: int = 0
var columns: int = 0

var min_board_position: Vector2i
var max_board_position: Vector2i

var cells_by_position: Dictionary = {}


func build_from_board(board: TileMapLayer):
	var used_cells := board.get_used_cells()

	if used_cells.is_empty():
		print("Board has no cells!")
		return

	_find_board_bounds(used_cells)
	_create_cells(used_cells)
	_connect_neighbours()

	print_board()
	var test_cell = get_cell(min_board_position)

	print("TEST CELL")
	print("Position: ", test_cell.board_position)
	print("Up: ", test_cell.up)
	print("Right: ", test_cell.right)
	print("Down: ", test_cell.down)
	print("Left: ", test_cell.left)


func _find_board_bounds(used_cells: Array[Vector2i]):
	var min_x := used_cells[0].x
	var max_x := used_cells[0].x
	var min_y := used_cells[0].y
	var max_y := used_cells[0].y

	for pos in used_cells:
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)

		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)

	min_board_position = Vector2i(min_x, min_y)
	max_board_position = Vector2i(max_x, max_y)

	columns = max_x - min_x + 1
	rows = max_y - min_y + 1


func _create_cells(used_cells: Array[Vector2i]):
	cells.clear()
	cells_by_position.clear()

	# Create empty matrix.
	for row in range(rows):
		var row_array: Array = []

		for column in range(columns):
			row_array.append(null)

		cells.append(row_array)

	# Create LogiCell objects.
	for board_position in used_cells:
		var relative_position := board_position - min_board_position

		var row := relative_position.y
		var column := relative_position.x

		var cell := LogiCell.new(board_position)

		cells[row][column] = cell
		cells_by_position[board_position] = cell


func get_cell(board_position: Vector2i) -> LogiCell:
	return cells_by_position.get(board_position)


func _connect_neighbours():
	for cell in cells_by_position.values():

		cell.up = get_cell(
			cell.board_position + Vector2i(0, -1)
		)

		cell.right = get_cell(
			cell.board_position + Vector2i(1, 0)
		)

		cell.down = get_cell(
			cell.board_position + Vector2i(0, 1)
		)

		cell.left = get_cell(
			cell.board_position + Vector2i(-1, 0)
		)


func get_direction(from: Vector2i, to: Vector2i) -> int:
	var difference := to - from

	if difference == Vector2i(0, -1):
		return LogiCell.DIR_UP

	if difference == Vector2i(1, 0):
		return LogiCell.DIR_RIGHT

	if difference == Vector2i(0, 1):
		return LogiCell.DIR_DOWN

	if difference == Vector2i(-1, 0):
		return LogiCell.DIR_LEFT

	return 0


func print_board():
	print("========== BOARD ==========")
	print("Rows: ", rows)
	print("Columns: ", columns)
	print("Min: ", min_board_position)
	print("Max: ", max_board_position)

	for row in range(rows):
		var text := ""

		for column in range(columns):
			var cell: LogiCell = cells[row][column]

			if cell == null:
				text += " . "
			else:
				text += " X "

		print(text)

	print("===========================")
