extends Noun

@export var level := 1
@export var species: String
@export var dexterity := int()
# Endurance belongs to the mass
@export var perception := int()
@export var intelligence := int()
@export var charisma := int()
@export var strength := int()
@export var ab_l : AbilitiesList
@export var default_verb: Verb
@export var initial_state: State
var current_state: State
var states_dict:= {}
var destination: Vector2
var in_combat:= false

signal play_prop


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



# Called when the player becomes selected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states_dict[child.name]= child
			child.next.connect(on_state_next)
	if initial_state:
		initial_state.enter()
		current_state= initial_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.update(delta)
	pass
