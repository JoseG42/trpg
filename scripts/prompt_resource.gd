class_name prompt extends RichTextLabel

@export var prompt_script := ""
var active_char := -1

func standby():
	self.text = prompt_script
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed == true and event.echo == false:
		print(event)
	pass
