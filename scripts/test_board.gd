extends Node2D

@onready var board: TileMapLayer = $Board

var dragging := false
var path : Array[Vector2i] = []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			
			var cell := get_touch_cell(event.position)
			path = [cell]
			print("pressed", cell)
		else:
			dragging = false
			print("Path: ", path)
	
	elif event is InputEventScreenDrag and dragging:
		var cell := get_touch_cell(event.position)
		
		if cell != path[-1]:
			path.append(cell)


func get_touch_cell(screen_position) -> Vector2i:
	return board.local_to_map(
		board.to_local(screen_position)
	)


func add_cell(cell: Vector2i):
	var previous := path[-1]
	var difference := cell - previous
	
	if abs(difference.x) + abs(difference.y) != 1:
		return
	
	path.append(cell)
	
