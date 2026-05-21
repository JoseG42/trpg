class_name Stage extends TileMapLayer

@export var player : Noun
@export var command : CommandInput
var all_npc := []
@onready var subject:= player
var verb : Verb
var object : Noun
var npc_dict:= {}
var verb_dict:={}
var player_combat := false


func _on_command_input_orange(i) -> bool:
	if i in verb_dict:
		verb = verb_dict[i]
		command.selected_verb(verb)
		return true
	elif i == player.name or i == player.name.to_lower():
		if verb:
			object= player
			player.targeted(verb)
			command.selected_object_player()
		else:
			subject= player
			player.selected()
			command.selected_subject_player()
		return true
	elif i in npc_dict:
		if verb:
			object= npc_dict[i]
			object.targeted(verb)
			command.selected_object_npc()
		else:
			subject= npc_dict[i]
			subject.selected()
			command.selected_subject_npc()
		return true
	else:
		command.mistake()
		return false

func _on_command_input_execute() -> void:
	#print("execute", subject, verb, object)
	var result
	if object != null:
		for v in subject.ab_l.get_children():
			if v.name == verb.name:
				result= v.act(object)
		object.deselected()
	else:
		for v in subject.ab_l.get_children():
			if v.name == verb.name:
				result= v.act()
	subject.deselected()
	subject= player
	verb= null
	object= null
	command.log.append_text(result+ "\n")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in self.get_children():
		if n is NPCClass:
			npc_dict[n.name]= n
			all_npc.append(n)
	for v in player.ab_l.get_children():
		if v.name not in verb_dict:
			verb_dict[v.name]= v
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
