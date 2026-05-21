extends State

#this should like a stamina
var act_points: int

func enter():
	act_points+= 2

func update():
	if act_points== 0:
		pass
