extends Area2D

@onready var combat_area: CollisionShape2D = $"Combat area"
@onready var active_turn_marker: AnimatedSprite2D = $ActiveTurnMarker
@export var player: Noun
var turn_number:= 0
var combat_array: Array

func sort_speed(a, b):
	if a.speed> b.speed:
		return true
	return false

func next_turn():
	turn_number+= 1
	for n in combat_array:
		active_turn_marker.position= n.position
		if n is NPCClass:
			active_turn_marker.modulate= TingeGlobal.CutRed
			n.play_turn()
		elif n == player:
			active_turn_marker.modulate= TingeGlobal.FastGreen
			player.play_turn()
	end_turn()

func end_turn():
	next_turn()
	pass

func start_combat():
	var b_array: Array
	for n in get_overlapping_areas():
		if n is NPCClass:
			b_array.append(n)
	b_array.append(player)
	b_array.sort_custom(sort_speed)
	combat_array= b_array
	active_turn_marker.position= combat_array[0].position
	active_turn_marker.visible= true
	for n in combat_array:
		active_turn_marker.position= n.position
		if n is NPCClass:
			active_turn_marker.modulate= TingeGlobal.CutRed
			n.play_turn()
		elif n == player:
			active_turn_marker.modulate= TingeGlobal.FastGreen
			player.play_turn()
	end_turn()




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
