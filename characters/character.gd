extends Node2D
class_name Character

@export var stats : Character_stats

var current_health : int
var max_health : int

var is_alive : bool = true

func _ready() -> void:
	current_health = stats.health
	max_health = stats.max_health
	$Sprite2D.texture = stats.texture
	
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

func act(_target):
	print("% age!")
