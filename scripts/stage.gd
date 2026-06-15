class_name Stage extends Node

@export var player : Noun
@export var initial_state: PlayState
@onready var subject:= player
@onready var verb: Verb
var all_npc := []
var not_npc_nouns:= []
var object : Noun
var npc_dict:= {}
var noun_dict:= {}
var verb_dict:= {}
var player_combat:= false
var enemies:= 0
var states:= {}
var current_state: PlayState


signal selected_v
signal selected_s
signal selected_s_p
signal selected_o
signal selected_o_p
signal mistake
signal action_taken
signal play_next_stage
signal queue_prompt

class word:
	var type: EnumGlobal.W_type
	var role: EnumGlobal.Role
	var text: String
	var index: int

func clear_selection():
	verb= player.default_verb
	if object:
		object.deselected()
	object= null
	subject.deselected()
	subject= player


func input_select(i) -> bool:
	if i in verb_dict:
		verb = verb_dict[i]
		if object:
			object.targeted(verb)
		selected_v.emit(verb.faith)
		return true
	elif i == player.name or i == player.name.to_lower():
		if verb:
			object= player
			player.targeted(verb)
			selected_o_p.emit()
		else:
			subject= player
			player.selected()
			selected_s_p.emit()
		return true
	elif i in npc_dict:
		if verb:
			object= npc_dict[i]
			object.targeted(verb)
			selected_o.emit()
		else:
			object= npc_dict[i]
			object.selected()
			selected_o.emit()
		return true
	elif i in noun_dict:
		if verb:
			object= noun_dict[i]
			object.targeted(verb)
			selected_o.emit()
		else:
			object= noun_dict[i]
			object.selected()
			selected_o.emit()
		return true
	else:
		mistake.emit()
		return false

func input_execute() -> bool:
	#print("execute", subject, verb, object)
	var result
	if object != null:
		for v in player.ab_l.get_children():
			if v.name == verb.name:
				result= v.act(object)
		object.deselected()
	else:
		for v in subject.ab_l.get_children():
			if v.name == verb.name:
				result= v.act()
	clear_selection()
	action_taken.emit(result)
	return true

func on_state_next(state, next_state_name):
	if state!= current_state:
		return
	var next_state=states[next_state_name]
	if !next_state:
		return
	if current_state:
		current_state.exit()
	next_state.enter()
	current_state= next_state
	pass

func player_play_prop(p):
	var next_prompt= PromptClass.new(p)
	queue_prompt.emit(next_prompt)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n in get_children():
		var n_formatted = n.name.capitalize().to_lower()
		if n is NPCClass:
			npc_dict[n_formatted]= n
			all_npc.append(n)
		elif n is Noun:
			noun_dict[n_formatted]= n
		elif n is PlayState:
			states[n.name.to_lower()]= n
			n.next.connect(on_state_next)
	for v in player.ab_l.get_children():
		if v.name.to_lower() not in verb_dict:
			verb_dict[v.name.to_lower()]= v
	if initial_state:
		initial_state.enter()
		current_state= initial_state
	if player:
		verb= player.default_verb
		player.play_prop.connect(player_play_prop)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
