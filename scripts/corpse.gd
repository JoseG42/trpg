class_name CorpseClass extends PropClass

@export var species: String

func _init(creature:NPCClass):
	name= creature.name
	species= creature.species
	#mass.weight= NPCClass.mass.weight
	max_health= creature.mass.weight
	print(str("created "+ name+ "'s corpse"))
	
