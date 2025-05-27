@tool
extends Node2D
class_name Character

@export var stats : Character_stats:
	set(value):
		stats = value
		if value:
			$Sprite.texture = value.texture

@onready var _focus = $Focus

var current_health : int
var max_health : int

var target_scale : float = 0.35

var is_alive : bool = true

func _ready() -> void:
	current_health = stats.health
	max_health = stats.max_health
	$Sprite.texture = stats.texture
	
func begin_turn():
	target_scale = 0.45
	
func end_turn():
	target_scale = 0.35
	
func take_damage(amount: int) -> void:
	if !is_alive:
		return
	current_health = clamp(current_health - amount, 0, stats.max_health)
	if current_health <= 0:
		die()
		
func die():
	is_alive = false
	print("%s morreu" % stats.character_name)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	queue_free()

func act(_action : Action, _target : Character):
	print("% age!")
	
func heal(amount : int) -> void:
	if !is_alive:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	print("%s cura %s de vida!" % [stats.character_name, amount])
	
func focus():
	_focus.show()

func unfocus():
	_focus.hide()
