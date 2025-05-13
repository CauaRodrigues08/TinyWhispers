extends Action
class_name Attack_action

@export var damage : int

func execute(_user, target : Character):
	target.take_damage(damage)
	print("%s de dano!" % damage)
