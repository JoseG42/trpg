class_name Noun extends Area2D

@export var max_health := int()
@export var faith := Color()
@export var description := ""
@export var mass : Mass
@export var nametag : NameTag
var is_selected := false
var is_targeted:= false

func selected():
	#print("player is selected")
	nametag.text = ""
	nametag.push_color(Color("yellow"))
	nametag.add_text(name)
	nametag.pop()
	is_selected = true

func deselected():
	nametag.text = ""
	nametag.push_color(faith)
	nametag.add_text(name)
	nametag.pop()
	is_selected = false

func targeted(v):
	nametag.text = ""
	nametag.push_color(Color("red"))
	nametag.add_text(name)
	nametag.pop()
	is_targeted = true
	print(name, " is targetted for", v)
	
