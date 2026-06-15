extends AspectRatioContainer

@onready var line:= $Margin/Line
@onready var nine:= $Nine
var random_letter:= [
	"a","g"," ","m","e","c","s","p","r","o"
]

func shrink():
	var nine_rect= nine.get_rect()
	var line_rect= line.get_rect()
	custom_minimum_size.x= line_rect.size.x
	#while line_rect.size.x< nine_rect.size.x:
		#custom_minimum_size-= Vector2(1,0)

func add_random_letter():
	var l= random_letter.pick_random()
	line.append_text(l)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#add_random_letter()
	var nine_rect= nine.get_rect()
	var line_rect= line.get_rect()
	if line_rect.size.y > nine_rect.size.y:
		var diff_y= line_rect.size.y- nine_rect.size.y
		var grow_y= round(diff_y/4)+ .1
		print(grow_y)
		custom_minimum_size+= Vector2(grow_y,0)
		#offset_bottom= -10
	pass
