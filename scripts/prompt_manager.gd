extends AspectRatioContainer

@onready var midle_m_container: MarginContainer = $HBoxContainer/MidleMContainer
@onready var p_nine_rect: NinePatchRect = $HBoxContainer/MidleMContainer/AspectRatioContainer/PNineRect
@onready var current_p_margin: MarginContainer = $HBoxContainer/MidleMContainer/AspectRatioContainer/PNineRect/CurrentPMargin
@onready var p_timer:= $PTimer
@onready var animator:= $PManagerAnimation
@onready var top_label_1: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer1/AspectRatioContainer2/VBoxContainer/TopLabel1
@onready var top_label_2: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer1/AspectRatioContainer2/VBoxContainer/TopLabel2
@onready var middle_label_1: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer2/AspectRatioContainer2/VBoxContainer/MiddleLabel1
@onready var middle_label_2: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer2/AspectRatioContainer2/VBoxContainer/MiddleLabel2
@onready var bottom_label_1: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer3/AspectRatioContainer2/VBoxContainer/BottomLabel1
@onready var bottom_label_2: RichTextLabel = $HBoxContainer/VBoxContainer/MContainer3/AspectRatioContainer2/VBoxContainer/BottomLabel2
@export var s_watch: SWatchClass
var p_dict:= {}
var p_total:= 0
var current_p: PromptClass
var current_p_index:= 0
var is_edit_focus:= true
var wpm:= 0.0

signal p_ready
signal idle

func idling():
	animator.play("idling")
	if wpm> PlayerStatsGlobal.ALLTIMEBESTWPM:
		PlayerStatsGlobal.ALLTIMEBESTWPM= wpm
	PlayerStatsGlobal.ALLTIMEWPMAVERAGE= (PlayerStatsGlobal.ALLTIMEWPMAVERAGE+ wpm)/2
	p_dict= {}
	p_total= 0
	current_p_index= 0

func resting():
	s_watch.reset()
	current_p.queue_free()
	visible= !visible
	animator.play("RESET")
	idle.emit()

func top_label_show_p_cent_correct(n):
	if n> 80.0:
		top_label_1.clear()
		top_label_2.clear()
		top_label_1.append_text("[color=#"+ str(TingeGlobal.FastGreen.to_html(false))+ "]"+ "Accuracy"+ "[/color]")
		top_label_2.append_text("[color=#"+ str(TingeGlobal.FastGreen.to_html(false))+ "]"+ str(n)+ "%[/color]")

func mid_label_show_n_missed(n):
	middle_label_1.clear()
	middle_label_1.append_text("[color=#"+ str(TingeGlobal.CutRed.to_html(false))+ "]"+ "Missed [/color]")
	middle_label_2.clear()
	middle_label_1.append_text("[color=#"+ str(TingeGlobal.CutRed.to_html(false))+ "]"+ str(n)+ "[/color]")

func bottom_label_update_wpm():
	if ! current_p:
		return
	var t= s_watch.time_elapsed
	var w_typed= current_p.current_w_index- 1
	if w_typed== 0:
		if bottom_label_1.text== "WPM:":
			var hue_0= TingeGlobal.CutRed.lerp(TingeGlobal.FastGreen, 0.5)
			bottom_label_1.clear()
			bottom_label_1.append_text("[color=#"+ str(hue_0.to_html(false))+ "]WPM:[/color]")
			bottom_label_2.clear()
			bottom_label_2.append_text("[color=#"+ str(hue_0.to_html(false))+ "]...[/color]")
		return
	wpm= w_typed/ (t/ 60)
	var wpm_factor= wpm/ (PlayerStatsGlobal.ALLTIMEWPMAVERAGE* 1.1)
	#print("wpm: ",str(wpm))
	var hue= TingeGlobal.CutRed.lerp(TingeGlobal.FastGreen, wpm_factor)
	bottom_label_1.clear()
	bottom_label_1.append_text("[color=#"+ str(hue.to_html(false))+ "]WPM:[/color]")
	bottom_label_2.clear()
	bottom_label_2.append_text("[color=#"+ str(hue.to_html(false))+ "]"+ str(snapped(wpm, 0.01))+ "[/color]")

func show_results():
	var total_correct:= 0.0
	var total_incorrect:= 0.0
	var l_total:= 0.0
	for p in p_dict:
		l_total+= p_dict[p].c_length
		total_correct+= p_dict[p].l_correct
		total_incorrect+= p_dict[p].l_incorrect
	print("total: ", str(l_total))
	print("total correct: ", str(total_correct))
	print("total incorrect: ", str(total_incorrect))
	var p_cent_correct= round((total_correct/ l_total)* 100)
	if total_incorrect> 10.0:
		var p_cent_incorrect= round((total_incorrect/ l_total)* 100)
	if p_cent_correct> 80.0:
		top_label_show_p_cent_correct(p_cent_correct)
		if total_incorrect<10.1:
			mid_label_show_n_missed(total_incorrect)

func _on_current_p_finished():
	s_watch.paused= true
	if current_p_index== p_total:
		#finished last prompt
		show_results()
		print("finished the prompt")
	is_edit_focus= true
	idling()

func queue_prompt(p):
	p_dict[p_total]= p

func _on_stage_queue_prompt(p) -> void:
	if ! visible:
		visible= true
	p_total+= 1
	current_p_margin.add_child(p)
	p.stand_by()
	if ! current_p:
		current_p= p
		p_dict[p_total]= current_p
		current_p_index+= 1
		current_p.finished.connect(_on_current_p_finished)
		current_p.play()
		await get_tree().create_timer(0.5).timeout
		p_ready.emit()

func _input(event: InputEvent) -> void:
	if is_edit_focus== false and current_p!= null:
		if event is InputEventKey and not event.is_pressed():
			#the typed key
			var t_key= event.as_text_keycode()
			#the currently expected key
			var c_key= current_p.current_w.current_l.c
			if s_watch.paused:	
				if t_key== "Shift":
					get_viewport().set_input_as_handled()
				elif c_key== c_key.to_upper() and t_key== str("Shift+",c_key):
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
					s_watch.paused= false
				elif c_key== t_key.to_lower():
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
					s_watch.paused= false
					#print("successfully typed: ", c_key)
				elif c_key== " " and t_key== "Space":
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
					s_watch.paused= false
				elif c_key== "." and t_key== "Period":
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
					s_watch.paused= false
				else:
					get_viewport().set_input_as_handled()
			else:
				if t_key== "Shift":
					get_viewport().set_input_as_handled()
				elif c_key== c_key.to_upper() and t_key== str("Shift+",c_key):
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
				elif c_key== t_key.to_lower():
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
					#print("successfully typed: ", c_key)
				elif c_key== " " and t_key== "Space":
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
				elif c_key!= " " and t_key== "Space":
					print("trying to skip a single word")
					current_p.current_w.skip()
				elif c_key== "." and t_key== "Period":
					current_p.current_w.next_l(EnumGlobal.Stts.CORRECT)
				else:
					current_p.current_w.next_l(EnumGlobal.Stts.INCORRECT)
					#print("WRONG. expected: ", c_key, " typed: ", t_key)

func _on_p_timer_timeout() -> void:
	pass # Replace with function body.

func _on_p_manager_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"idling":
			resting()
	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_p:
		if current_p_margin.size.y> p_nine_rect.size.y:
			print("should expand")
			midle_m_container.size_flags_stretch_ratio+= 0.1
		elif current_p_margin.size.y< p_nine_rect.size.y:
			print("should shrink")
			midle_m_container.size_flags_stretch_ratio-= 0.1
	if s_watch.paused:
		return
	else:
		bottom_label_update_wpm()
