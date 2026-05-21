extends Noun

@export var level := 1
@export var dexterity := int()
# Endurance belongs to the mass
@export var perception := int()
@export var intelligence := int()
@export var charisma := int()
@export var strength := int()
@export var ab_l : AbilitiesList
@export var initial_state: State
var states:= {}
var in_combat:= false


# Called when the player becomes selected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
