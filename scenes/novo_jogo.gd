extends TextureButton

func _on_pressed():
	Transiçãomenu.transition()
	await Transição.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/salão.tscn")
