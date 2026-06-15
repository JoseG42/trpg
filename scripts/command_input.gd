class_name CommandInput extends Control

@onready var edit = $EditMargin/CommandEdit
@onready var log = $LogMargin/LogRatio/CommandLog
@onready var line= $LineMargin/AspectRatioContainer/CommandLine
@export var stage: Stage
var last_word:= ""
var current_word:=0
var sent:= {}
signal orange
signal execute

func log_action_taken()-> bool:
	for w in sent:
		log.append_text(sent[w])
	log.append_text("\n")
	return true

func selected_subject_player():
	sent[current_word]= str("[color= blue] ", last_word, " [/color]") 
	line.clear()
	for w in sent:
		line.append_text(sent[w])
	pass

func selected_subject_npc():
	sent[current_word]= str("[color= yellow] ", last_word, " [/color]")
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func selected_verb(v):
	var hue= v.faith
	sent[current_word]= "[color=#"+ str(hue.to_html(false))+ "] "+ last_word+ " [/color]"
	line.clear()
	line.bbcode_enabled = true
	for w in sent:
		line.append_text(sent[w])

func selected_object_player():
	sent[current_word]= str("[color= green]", last_word, "[/color]")
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func selected_object_npc():
	sent[current_word]= str("[color= red]", last_word, "[/color]")
	line.clear()
	for w in sent:
		line.append_text(sent[w])

func mistake():
	var wrong_sent:= {}
	for w in sent:
		wrong_sent[w]= sent[w]
	wrong_sent[current_word]= str("[color= red] [s]", last_word, "[/s] [/color]")
	line.clear()
	for w in wrong_sent:
		log.append_text(wrong_sent[w])
	log.append_text("\n")
	current_word-= 1
	for w in sent:
		line.append_text(sent[w])
	log.append_text(str(last_word, " is not available \n"))

func _input(event: InputEvent) -> void:
	if event.is_action_released("backspace"):
		if edit.text:
			edit.clear()
			line.clear()
			for w in sent:
				line.append_text(sent[w])
		elif not edit.text and last_word != "":
			edit.clear()
			line.clear()
			sent.erase(current_word)
			current_word-= 1
			for w in sent:
				line.append_text(sent[w])
		else:
			edit.clear()
			line.clear()
			sent= {}
			current_word= 0
			last_word= ""
			stage.clear_selection()
	if event.is_action_released("select"):
		edit.clear()
	if event.is_action_released("submit"):
		edit.clear()
		line.clear()
		sent= {}
		current_word= 0
		last_word= ""
	if event.is_action_pressed("submit"):
		if edit.text:
			last_word= edit.text
			current_word+= 1
			var valid = await stage.command_input_select(last_word.to_lower())
			if !valid:
				stage.clear_selection()
				return
		stage.command_input_execute()
	elif event.is_action_pressed("select"):
		last_word= edit.text
		current_word+= 1
		stage.command_input_select(last_word.to_lower())
	else:
		pass
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	edit.grab_focus()
	#edit.vis
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_command_edit_text_changed(new_text: String) -> void:
	if new_text != "":
		line.append_text(str(new_text.split("")[-1]))
	pass # Replace with function body.
