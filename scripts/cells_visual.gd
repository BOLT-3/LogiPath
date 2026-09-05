extends Node2D

const CELL_COLOR := Color(0.85, 0.85, 0.85)
const LINE_COLOR := Color(0.2, 0.2, 0.2)

var board


func set_board(new_board):
	board = new_board
	queue_redraw()


func _draw():
	if board == null:
		return

	for position in board.cells:
		draw_cell(position, board.CELL_SIZE)


func draw_cell(position: Vector2i, cell_size: float):
	var pixel_position := Vector2(position) * cell_size
	var rect := Rect2(pixel_position, Vector2(cell_size, cell_size))

	draw_rect(rect, CELL_COLOR)
	draw_rect(rect, LINE_COLOR, false, 2.0)
