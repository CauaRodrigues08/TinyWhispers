extends Node2D

@onready var player_characters_node = $player_characters

func _ready() -> void:
	var player_characters = player_characters_node.get_children()
	for i in range(player_characters.size()):
		player_characters[i].position = Vector2(i * 120, 0)
