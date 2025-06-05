extends Button

func _on_pressed():
	Transição.transition()
	await Transição.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/pirata.tscn")
