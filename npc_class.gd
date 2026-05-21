class_name NPCClass extends Noun

@export var level := int()
@export var dexterity := int()
# Endurance belongs to the mass
@export var perception := int()
@export var intelligence := int()
@export var charisma := int()
@export var strength := int()
@export var ab_l : AbilitiesList
@export var initial_state: State
var current_state: State
var states_dict:= {}
var in_combat:= false

func on_state_next(state, next_state_name):
	if state!= current_state:
		return
	var next_state=states_dict[next_state_name]
	if !next_state:
		return
	if current_state:
		current_state.exit()
	next_state.enter()
	current_state= next_state
	pass

func _ready() -> void:
	for child in get_children():
		if child is State:
			states_dict[child.name]= child
			child.next.connect(on_state_next)
	if initial_state:
		initial_state.enter()
		current_state= initial_state
	pass

func _process(delta: float) -> void:
	if current_state:
		current_state.update()
	pass
