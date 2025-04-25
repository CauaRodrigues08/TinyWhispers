extends Node2D
class_name Character

@export var character_name : String
@export var max_health : int = 100
@export var health : int = 100:
	set(value):
		health = clamp(value, 0, max_health)
		if health <= 0:
			is_alive = false

var is_alive : bool = true:
	set(value):
		is_alive = value
		if is_alive == false:
			print("%s has died" % character_name)

@export var actions : Array[Resource] = []

func _ready() -> void:
	pass 
