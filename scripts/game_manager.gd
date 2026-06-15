extends Node

@onready var edit:= $Edit
@onready var l_ratio:= $LineRatio
@onready var line= l_ratio.line
@onready var current_stage: Stage= $TitleScreen
@onready var annals:= $Log
@onready var p_manager:= $PromptManager
var sent:= {}
var current_w:= ""
var current_w_index:= 0
var last_w:= ""

	
func _selected_v(hue):
	sent[current_w_index]= "[color=#"+ str(hue.to_html(false))+ "] "+ last_w+ " [/color]"
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func _selected_subject_player():
	sent[current_w_index]= str("[color= blue] ", last_w, " [/color]") 
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func _selected_object_player():
	sent[current_w_index]= str("[color= green] ", last_w, " [/color]") 
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func _selected_subject():
	sent[current_w_index]= str("[color= yellow] ", last_w, " [/color]") 
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func _selected_object():
	sent[current_w_index]= str("[color= red] ", last_w, " [/color]") 
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func _mistake():
	var wrong_sent:= {}
	for w in sent:
		wrong_sent[w]= sent[w]
	wrong_sent[current_w_index]= str("[color= red] [s]", last_w, "[/s] [/color]")
	line.clear()
	for w in wrong_sent:
		annals.append_text(wrong_sent[w])
	annals.append_text("\n")
	current_w_index-= 1
	for w in sent:
		line.append_text(sent[w])
	annals.append_text(str(last_w, " is not available \n"))

func _record_action_taken(result):
	for w in sent:
		annals.append_text(sent[w])
	annals.append_text("\n")
	annals.append_text(result+ "\n")
	pass

func _play_next_stage(stage):
	add_child(stage)
	var last_stage= current_stage
	current_stage= stage
	connect_stage_signals(current_stage)
	last_stage.queue_free()
	print("playing: ", stage)

func connect_stage_signals(sender):
	sender.selected_v.connect(_selected_v)
	sender.selected_s_p.connect(_selected_subject_player)
	sender.selected_o_p.connect(_selected_object_player)
	sender.selected_s.connect(_selected_subject)
	sender.selected_o.connect(_selected_object)
	sender.mistake.connect(_mistake)
	sender.action_taken.connect(_record_action_taken)
	sender.play_next_stage.connect(_play_next_stage)
	sender.queue_prompt.connect(p_manager._on_stage_queue_prompt)

func _on_edit_text_changed(new_text: String)-> void:
	#print(new_text)
	line.append_text(str(new_text.split("")[-1]))
	current_w+=(str(new_text.split("")[-1]))
	pass

func _on_p_manager_p_ready():
	edit.set_focus_behavior_recursive(Control.FOCUS_BEHAVIOR_DISABLED)
	p_manager.is_edit_focus= false

func _on_p_manager_idle():
	edit.set_focus_behavior_recursive(Control.FOCUS_BEHAVIOR_ENABLED)
	edit.grab_focus()
	PlayerStatsGlobal.save()

func _input(event: InputEvent) -> void:
	if event.is_action_released("backspace"):
		var current_w_array= current_w.split(" ")
		print(current_w_array)
		print(current_w_array.size())
		if current_w_index== 0 and current_w_array.size()== 1:
			current_w= ""
		elif current_w_index== 0 and current_w_array.size()> 1:
			var del= current_w_array[-1]
			var del_index= current_w.find(del)
			#print("del: ", del, " index: ", del_index, " length: ", del.length())
			current_w= current_w.erase(del_index- 1, del.length()+ 1)
			#print("after erase: ", current_w)
			line.append_text(current_w)
		elif current_w_index> 0 and current_w_array.size()== 1:
			current_w= ""
			for w in sent:
				line.append_text(sent[w])
		elif current_w_index> 0 and current_w_array.size()> 1:
			var del= current_w_array[-1]
			var del_index= current_w.find(del)
			current_w= current_w.erase(del_index- 1 ,del.length()+ 1)
			for w in sent:
				line.append_text(sent[w])
			line.append_text(" "+current_w)
		elif current_w_index== 1 and current_w== "":
			current_w= ""
			sent= {}
			current_w_index= 0
			last_w= ""
		elif current_w_index> 1 and current_w== "":
			current_w= ""
			sent.erase(current_w_index)
			current_w_index-= 1
			for w in sent:
				line.append_text(sent[w])
		l_ratio.shrink()
	if event.is_action_pressed("backspace"):
		edit.clear()
		line.clear()
	if event.is_action_released("select"):
		edit.clear()
		current_w= ""
	if event.is_action_released("submit"):
		edit.clear()
		line.clear()
		current_w= ""
		sent= {}
		current_w_index= 0
		last_w= ""
	if event.is_action_pressed("submit"):
		if current_w != "":
			last_w= current_w
			current_w_index+= 1
			var valid = await current_stage.input_select(last_w.to_lower())
			if !valid:
				current_stage.clear_selection()
				#I may need to add more here
		current_stage.input_execute()
	if event.is_action_pressed("select"):
		last_w= current_w
		current_w_index+= 1
		current_stage.input_select(last_w.to_lower())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	edit.grab_focus()
	connect_stage_signals(current_stage)
	PlayerStatsGlobal.load_p_stats()
	get_tree().set_auto_accept_quit(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
