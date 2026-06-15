extends Verb

func act(target = subject):
	if target is GameClass:
		target.load_game()
		return subject.name+ " plays "+ target.name
	elif target is PropClass:
		#var p= PromptClass.new(target.description)
		subject.play_prop.emit(target.description)
		return subject.name+ " plays "+ target.name
	else:
		print("play expects a game")
