extends Node2D
class_name Character

var id = ""
var character_name = ""
var type = ""
var max_hp : int
var current_hp : int
var speed : int
var actions = []
var status_effects = []


func setup(data: Dictionary):
	id = data.get("id", "")
	character_name = data.get("name", "")
	type = data.get("type", "")
	max_hp = data.get("max_hp", 0)
	current_hp = max_hp
	speed = data.get("speed", 0)
	actions = data.get("actions", [])
