extends Control

@onready var line_cont:= $AspectRatioContainer
@onready var Ui_grid:= $GridContainer

func set_line_cont_start():
	line_cont.size=Vector2(100,100)
	var line_size= line_cont.get_size()
	print(line_size)
	line_cont.anchor_left= 0.5
	line_cont.anchor_right= 0.5
	line_cont.anchor_bottom= .5
	line_cont.anchor_top= .5
	line_cont.offset_bottom= 50
	line_cont.offset_left= 50
	line_cont.offset_right= 50
	line_cont.offset_top= 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_line_cont_start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
