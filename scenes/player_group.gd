extends Node2D

@onready var characters_node : Node2D = $Characters
var player_characters : Array = [Character]

func _ready():
	player_characters = characters_node.get_children()
	
	for i in range(player_characters.size()):
		player_characters[i].position = Vector2(i * 120, 0)
