class_name Verb extends RichTextLabel

@export var priority := int()
@export var duration := int()
var subject : Noun
@export var level := int()
@export var faith: Color

func act(target = subject):
	print(target.name, " is able to perform verbs")
	return target.name+ "is able to perform verbs"

func _ready() -> void:
	text = name
