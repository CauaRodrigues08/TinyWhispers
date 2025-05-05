extends Resource
class_name Action

@export var name: String
@export var description: String
@export var icon: Texture2D

func execute(user : Character, target : Character):
	print("%s usa %s em %s!" % [user.character_name, name, target.character_name])
