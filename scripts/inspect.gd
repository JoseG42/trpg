extends Verb

func act(target= subject):
	if target is NPCClass:
		var a= str(target.name)
		var lvl= str(target.level)
		var b= str(target.species)
		return a+ " is a level "+ lvl+ " "+ b+ " "+ "\""+ target.description+ "\""
	elif target is Noun:
		return str(target.description)
	elif target== subject:
		var a= str(target.name)
		var lvl= str(target.level)
		var b= str(target.species)
		return a+ " is a level "+ lvl+ " "+ b+ " "+ "\""+ target.description+ "\""
		
