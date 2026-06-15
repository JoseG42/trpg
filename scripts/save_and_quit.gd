extends Verb

func act(target= subject):
	PlayerStatsGlobal.save()
	get_tree().quit()
	return str("saved game")
