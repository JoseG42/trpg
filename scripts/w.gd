class_name WordClass extends HBoxContainer

var letters:=[]
var length:= letters.size()
var l_dict:= {}
var current_l: CharacterClass
var current_l_index:= 1
var first:= false
var last:= false
var single:= false
var status: EnumGlobal.Stts
var l_correct:= 0
var l_incorrect:= 0
var l_skipped:= 0

signal next
signal finish
signal count

func is_current():
	status= EnumGlobal.Stts.CURRENT
	current_l= l_dict[current_l_index]

func next_l(st:EnumGlobal.Stts):
	count.emit(st, 1)
	match st:
		EnumGlobal.Stts.CORRECT:
			#print("current: ", current_l.c, " is last:", str(current_l.last), " is first:", str(current_l.first))
			current_l.mark_correct()
			l_correct+= 1
			current_l_index+= 1
			if last and current_l.last:
				finish.emit()
			elif current_l.last:
				next.emit(EnumGlobal.Stts.FINISHED)
			else:
				current_l= l_dict[current_l_index]
				#print("next: ", current_l.c, " is last:", str(current_l.last))
		EnumGlobal.Stts.INCORRECT:
			#print("current: ", current_l.c, " is last:", str(current_l.last))
			current_l.mark_incorrect()
			l_incorrect+= 1
			current_l_index+= 1
			if last and current_l.last:
				finish.emit()
			elif current_l.last:
				next.emit(EnumGlobal.Stts.FINISHED)
			else:
				current_l= l_dict[current_l_index]
				#print("next: ", current_l.c, " is last:", str(current_l.last))
		EnumGlobal.Stts.SKIPPED:
			current_l.mark_skipped()
			l_skipped+= 1
			current_l_index+= 1
			if last and current_l.last:
				finish.emit()
				print("emitted finish")
			elif  current_l.last:
				next.emit(EnumGlobal.Stts.SKIPPED)
				print("emitted next")
			else:
				current_l= l_dict[current_l_index]

func skip():
	status= EnumGlobal.Stts.SKIPPED
	for l in l_dict:
		if l_dict[l].status== EnumGlobal.Stts.UNWRITTEN:
			next_l(EnumGlobal.Stts.SKIPPED)
	#current_l.mark_skipped()
	#print("skipped: ", str(current_l.c), current_l)
	#if last:
	#	for l in l_dict:
	#		if l_dict[l].status== EnumGlobal.Stts.UNWRITTEN:
	#			l_skipped+= 1
	#			l_dict[l].mark_skipped()
	#			#finish.emit()
	#else:
	#	for l in l_dict:
	#		if l_dict[l].status== EnumGlobal.Stts.UNWRITTEN:
	#			l_skipped+= 1
	#			l_dict[l].mark_skipped()
	#			print("skipped: ", str(l_dict[l].c), l_dict[l])
	#count.emit(EnumGlobal.Stts.SKIPPED, l_skipped)

func _init(t: String , is_first: bool= false, is_last: bool= false):
	letters = t.split("")
	first= is_first
	last= is_last
	var new_c
	var c_count= 0
	if last== false:
		letters. append(" ")
	length = letters.size()
	if first and last:
		single= true
	if length== 1:
		new_c= CharacterClass.new(true, letters[0], true)
		new_c.bbcode_enabled= true
		new_c.fit_content= true
		#new_c.theme= load("res://assets/FontTheme01.tres")
		#new_c.add_theme_font_size_override("FontTheme01", 16)
		new_c.clip_contents= false
		add_child(new_c)
		l_dict[length]= new_c
		#print(new_c.c)
	else:
		for l in letters:
			if c_count== 0:
				new_c= CharacterClass.new(true, l, false)
				new_c.bbcode_enabled= true
				new_c.fit_content= true
				#new_c.theme= load("res://assets/FontTheme01.tres")
				#new_c.add_theme_font_size_override("FontTheme01", 16)
				new_c.clip_contents= false
				add_child(new_c)
				c_count+= 1
				l_dict[c_count]= new_c
				#print(new_c.c)
			elif c_count== length- 1:
				new_c= CharacterClass.new(false, l, true)
				new_c.bbcode_enabled= true
				new_c.fit_content= true
				#new_c.theme= load("res://assets/FontTheme01.tres")
				#new_c.add_theme_font_size_override("FontTheme01", 16)
				new_c.clip_contents= false
				add_child(new_c)
				c_count+= 1
				l_dict[c_count]= new_c
				#print(new_c.c)
			else:
				new_c= CharacterClass.new(false, l, false)
				new_c.bbcode_enabled= true
				new_c.fit_content= true
				#new_c.theme= load("res://assets/FontTheme01.tres")
				#new_c.add_theme_font_size_override("FontTheme01", 20)
				new_c.clip_contents= false
				add_child(new_c)
				c_count+= 1
				l_dict[c_count]= new_c
				#print("count: ", str(count), " of: ", str(length))
	add_theme_constant_override("separation",-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	status= EnumGlobal.Stts.STANDBY
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
