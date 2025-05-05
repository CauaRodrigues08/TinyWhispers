extends Action
class_name Attack_action

@export var damage : int

func execute(user, target):
	target.take_damage(damage)
	print("%s deu %s de dano!" % [user.character_name, damage])
