extends Action
class_name Heal_action 

@export var amount : int 

func execute(_user, target : Character):
	if !target.is_alive:
		return
	target.heal(amount)
	print("%s de cura!" % amount)
