class_name Mass extends CollisionShape2D

@export var weight := int()
@export var endurance := int()
@export var noun : Noun
var current_hp := float()
var speed := float()

func damaged(dmg:float):
	current_hp -= dmg - (endurance * 0.6 - 1)
	if current_hp < 0.0:
		print(noun.name, " has died")
		noun.destroyed()
	
func healed(aid:float):
	if current_hp + (aid + (endurance * 0.3)) > noun.max_health:
		current_hp = noun.max_health
	else:
		current_hp += aid + (endurance * 0.3)

func _ready() -> void:
	current_hp = noun.max_health
