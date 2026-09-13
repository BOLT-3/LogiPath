extends RefCounted
class_name LogiCell


enum ContentType {
	EMPTY,
	DOT,
	CONSTRAINT
}


enum DotType {
	START,
	END
}


enum ConstraintType {
	ARROW
}


enum ColorType {
	NONE,
	RED
}


# Directions are represented as bits.
const DIR_UP = 1
const DIR_RIGHT = 2
const DIR_DOWN = 4
const DIR_LEFT = 8


# Position of this cell on the board.
var board_position: Vector2i


# -------------------------
# Cell structure
# -------------------------

# Which sides of the cell have walls.
# 0 means no walls.
var wall_mask: int = 0


# -------------------------
# Cell content
# -------------------------

# A cell can have ONE content type.
var content_type: ContentType = ContentType.EMPTY

# Only meaningful when content_type == DOT.
var dot_type: DotType

# Only meaningful when content_type == CONSTRAINT.
var constraint_type: ConstraintType


# -------------------------
# Line
# -------------------------

# Color of the line passing through this cell.
# NONE means there is currently no line.
var line_color: ColorType = ColorType.NONE

# Which directions the line connects to.
var line_mask: int = 0


# -------------------------
# Neighbours
# -------------------------

var up: LogiCell = null
var right: LogiCell = null
var down: LogiCell = null
var left: LogiCell = null


func _init(pos: Vector2i):
	board_position = pos


func has_wall(direction: int) -> bool:
	return (wall_mask & direction) != 0


func has_line(direction: int) -> bool:
	return (line_mask & direction) != 0
