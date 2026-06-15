class_name CharacterClass extends RichTextLabel

var c: String
var status: EnumGlobal.Stts
var first:= false
var last:= false
var typed:= false

func _init(is_first: bool= false, t= " ", is_last: bool= false) -> void:
	first= is_first
	c= t
	last= is_last
	autowrap_mode=TextServer.AUTOWRAP_OFF

func mark_incorrect():
	clear()
	push_color(Color(1.0, 0.0, 0.0, 1.0))
	append_text(c)
	pop()
	status= EnumGlobal.Stts.INCORRECT

func mark_correct():
	clear()
	push_color(Color(0.0, 1.0, 0.0, 1.0))
	append_text(c)
	pop()
	status= EnumGlobal.Stts.CORRECT

func mark_skipped():
	clear()
	push_color(Color(1.0, 0.0, 0.0, 1.0))
	push_strikethrough(Color())
	append_text(c)
	pop()
	status= EnumGlobal.Stts.SKIPPED
	print("skipped: ", c)

#func is_current()-> bool:
	#return true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	append_text(c)
	if first:
		status= EnumGlobal.Stts.CURRENT
	else:
		status= EnumGlobal.Stts.UNWRITTEN
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
