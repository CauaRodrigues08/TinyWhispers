@tool
extends Node2D
class_name Character

@export var stats : Character_stats:
	set(value):
		stats = value
		if value:
			$Sprite.texture = value.texture


var current_health : int
var max_health : int

var target_scale : float = 0.35

var is_alive : bool = true


	

	
