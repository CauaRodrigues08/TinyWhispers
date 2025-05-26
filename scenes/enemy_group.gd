extends Node2D

@onready var characters_node : Node2D = $Characters
var enemies : Array = [Character]

func _ready():
	enemies = characters_node.get_children()
	
	for i in range(enemies.size()):
		enemies[i].position = Vector2(i * 120, 0)
