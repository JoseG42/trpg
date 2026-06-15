class_name AbilitiesList extends VBoxContainer

@export var subject : Noun
var abilities := []

func _ready() -> void:
	for v in self.get_children():
		v.subject = subject
		abilities.append(Verb)
		pass
