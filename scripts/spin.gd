extends Verb
# spin should cause the subject to spin in place around their y axis
func act(target = subject):
	print(target.name, " spins")
	return target.name+ " spins"
