class_name NameTag extends RichTextLabel

@export var noun : Noun

func _ready() -> void:
	push_color(noun.faith)
	add_text(noun.name.capitalize())
	pop()
