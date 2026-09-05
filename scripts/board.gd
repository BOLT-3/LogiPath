extends Node2D

const CELL_SIZE := 80.0

@onready var cells_visual = $CellsVisual

var cells: Dictionary = {}

var board_shape = [
	"11111",
	"11111",
	"00111",
	"00111",
	"00011"
]


func _ready():
	create_board()
	cells_visual.set_board(self)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			handle_press(event.position)

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			handle_press(event.position)


func handle_press(screen_position: Vector2):
	var cell_position = screen_to_cell(screen_position)

	if cells.has(cell_position):
		print("Touched cell: ", cell_position)


func screen_to_cell(screen_position: Vector2) -> Vector2i:
	var local_position = to_local(screen_position)
	
	var x = floor(local_position.x / CELL_SIZE)
	var y = floor(local_position.y / CELL_SIZE)
	
	return Vector2i(x, y)


func create_board():
	for y in range(board_shape.size()):
		for x in range(board_shape[y].length()):
			if board_shape[y][x] == "1":
				add_cell(Vector2i(x, y))


func add_cell(position: Vector2i):
	var cell = Cell.new(position)
	cells[position] = cell
