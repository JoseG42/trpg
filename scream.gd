extends Verb

func act(target = subject):
	if target == subject:
		print(target.name, " screams out loud")
		return target.name+ " screams out loud"
	else:
		print(subject.name, " screams at", target)
		return subject.name+ " screams at "+ target.name
