extends Verb

func act(target= subject):
	PlayerStatsGlobal.save()
	return "saved game"
