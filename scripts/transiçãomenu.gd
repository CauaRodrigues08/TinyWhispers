extends CanvasLayer

signal on_transition_finished
@onready var color_rect = $ColorRect2
@onready var animation_player = $AnimationPlayer2

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black2":
		on_transition_finished.emit()
		# Não toca fade_to_normal2 aqui
	elif anim_name == "fade_to_normal2":
		color_rect.visible = false
		hide()
		
func transition_to(path):
	color_rect.visible = true
	animation_player.play("fade_to_black2")
	await on_transition_finished
	get_tree().change_scene_to_file(path)
	animation_player.play("fade_to_normal2")
