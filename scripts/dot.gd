extends Node2D

enum DotType {START, END}

@export var dot_color: Color = Color.RED
@export var dot_type: DotType = DotType.START

@onready var label: Label = $Label
@onready var dot: Sprite2D = $ColorDot


func _ready():
	if dot_type == DotType.START:
		label.text = "S"
	else:
		label.text = "E"
	
	dot.self_modulate = dot_color
