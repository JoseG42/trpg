extends Verb
var base_dmg:= 15.0

func dmg_calc(target) ->float:
	var dmg= base_dmg* (1+ subject.strength* 0.05)
	dmg= dmg- (target.mass.endurance* 0.6 - 1)
	return dmg

func act(target= subject):
	if target== subject:
		if target.in_combat== false:
			target.in_combat= true
			#target.attacking(self)
		return target.name+ " slashes furiously"
	else:
		var dmg= dmg_calc(target)
		target.mass.damaged(dmg)
		return subject.name+ " slashed "+ target.name+ " dealing "+ str(dmg)+ " damage"
