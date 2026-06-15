class_name State extends Node

signal next
# This is a blank state

func enter():
	print("this character enters the ", name, " state")
	pass

func exit():
	print("this character exits the ", name, " state")
	pass

func update(delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
