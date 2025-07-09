extends Button

func _on_pressed():
	BattleData.current_enemy_id = "1002"
	Transição.transition()
	await Transição.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/battle_scene.tscn")
