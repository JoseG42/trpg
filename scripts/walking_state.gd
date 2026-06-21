extends State

var walker: Noun

func update(delta):
	pass
	#print("pos: ", walker.position)
	#print("des: ", walker.destination)
	#if walker.position.round()== walker.destination.round():
	#	print("arrived")
	#	next.emit(self, "State")
	#if walker.destination.x> walker.position.x:
	#	walker.position.x+= 10*delta
	#elif walker.destination.x< walker.position.x:
	#	walker.position.x-= 10*delta
	#if walker.destination.y> walker.position.y:
	#	walker.position.y+= 10*delta
	#elif walker.destination.y< walker.position.y:
	#	walker.position.y-= 10*delta

func _ready() -> void:
	walker= get_parent()
