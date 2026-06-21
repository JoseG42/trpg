extends Verb

func act(target= subject):
	if target== subject:
		#ask for a destination, or direction
		return subject.name+ " walks to "+ target.name
	elif target is Noun:
		#subject.current_state.next.emit(subject.current_state, "WalkingState")
		#subject.destination= target.position
		subject.navigation_agent_2d.target_position= target.position
		#var goal= target.position
		#while subject.position != goal:
			#if goal.x > subject.position.x:
				#subject.position.x+= 1
			#elif goal.x < subject.position.x:
				#subject.position.x-= 1
			#if goal.y> subject.position.y:
				#subject.position.y+= 1
			#elif goal.y< subject.position.y:
				#subject.position.y-= 1
		return subject.name+ " walks to "+ target.name
	pass
