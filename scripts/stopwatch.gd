class_name SWatchClass extends Node

var paused:= true
var time_elapsed:= 0.0
var laps_dict:= {}
var current_l_index:=1
var current_lap:=0.0

func reset():
	time_elapsed= 0.0
	current_l_index= 1

func lap():
	laps_dict[current_l_index]=time_elapsed
	current_lap= 0.0
	current_l_index+= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paused:
		return
	else:
		time_elapsed+= delta
	if current_l_index> 1:
		current_lap+= delta
