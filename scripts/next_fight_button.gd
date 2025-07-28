extends Button

func _on_pressed():
	if BattleData.current_enemy_id == "1001":
		BattleData.current_enemy_id = "1002"
	elif BattleData.current_enemy_id == "1002":
		BattleData.current_enemy_id = "1003"
	elif  BattleData.current_enemy_id == "1003":
		Transição.transition()
		await Transição.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/creditos.tscn")
		return
		
	Transição.transition()
	await Transição.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/battle_scene.tscn")
