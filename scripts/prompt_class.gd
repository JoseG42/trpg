class_name PromptClass extends HFlowContainer

@export var prompt:= ""
@onready var first_w= w_dict[1]
var current_w: WordClass
var current_w_index:= 1
var words:= []
var w_length:= words.size()
var w_dict:= {}
var c_length:= 0.0
var status: EnumGlobal.Stts
var l_correct: float
var l_incorrect: float
var w_skipped: float
var skipped_limit: int
var p_cent_correct: float
var p_cent_incorrect: float
var p_cent_pass: float
var p_cent_fail: float

signal finished

func play():
	status= EnumGlobal.Stts.CURRENT
	current_w_index= 1
	first_w.is_current()
	current_w= first_w


func stand_by():
	status= EnumGlobal.Stts.STANDBY
	

func next_w(st: EnumGlobal.Stts):
	if st== EnumGlobal.Stts.SKIPPED:
		print("skipped word")
	current_w_index+= 1
	current_w= w_dict[current_w_index]
	current_w.is_current()

func finish_p():
	current_w= null
	match status:
		EnumGlobal.Stts.CURRENT:
			if p_cent_correct> p_cent_pass:
				print("pass")
			elif p_cent_incorrect> p_cent_fail:
				print("fail")
			else:
				print("satisfactory")
	finished.emit()
	print("finished")

func resize():
	custom_minimum_size= Vector2(100,100)
	position= Vector2(1,-100)

func _on_w_count(st: EnumGlobal.Stts, n: int):
	match st:
		EnumGlobal.Stts.CORRECT:
			l_correct+= n
			p_cent_correct= l_correct/ c_length
		EnumGlobal.Stts.INCORRECT:
			l_incorrect+= n
			p_cent_incorrect= l_incorrect/ c_length
		EnumGlobal.Stts.SKIPPED:
			w_skipped+= 1
			l_incorrect+= n
			p_cent_incorrect= l_incorrect/ c_length
			if status== EnumGlobal.Stts.CURRENT and w_skipped/ w_length> skipped_limit:
				status= EnumGlobal.Stts.SKIPPED

func _init(t: String) -> void:
	words= t.split(" ")
	w_length= words.size()
	var new_w: WordClass
	if w_length== 1:
		new_w= WordClass.new(words[0], true, true)
		add_child(new_w)
		w_dict[w_length]= new_w
		new_w.next.connect(next_w)
		new_w.finish.connect(finish_p)
		new_w.count.connect(_on_w_count)
	else:
		var count:= 0
		for w in words:
			if count== 0:
				new_w= WordClass.new(w, true, false)
				add_child(new_w)
				count+= 1
				w_dict[count]= new_w
				new_w.next.connect(next_w)
				new_w.count.connect(_on_w_count)
				#print(new_w)
			elif count== w_length-1:
				new_w= WordClass.new(w, false, true)
				add_child(new_w)
				count+= 1
				w_dict[count]= new_w
				new_w.next.connect(next_w)
				new_w.finish.connect(finish_p)
				new_w.count.connect(_on_w_count)
				#print(new_w)
			else:
				new_w= WordClass.new(w)
				add_child(new_w)
				count+= 1
				w_dict[count]= new_w
				new_w.next.connect(next_w)
				new_w.count.connect(_on_w_count)
				#print(new_w)
	add_theme_constant_override("h_separation", -1)
	add_theme_constant_override("v_separation", -1)
	alignment=FlowContainer.ALIGNMENT_CENTER
	size_flags_vertical= Control.SIZE_SHRINK_CENTER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for w in w_dict:
		c_length+= w_dict[w].length
	print("c length: ", str(c_length))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
