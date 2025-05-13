extends Node2D

@export var player_character : Character
@export var ai_character : Character
var current_character : Character

var game_over : bool = false

func next_turn ():
	if game_over:
		pass

	if current_character != null:
		current_character.end_turn()
		
	if current_character == ai_character or current_character == null:
		current_character = player_character
	else:
		current_character = ai_character
		
	current_character.begin_turn()
	
	if current_character == player_character:
		pass
		# ativar interface de combate
	else:
		# desativar interface do jogador
		await get_tree().create_timer(1.0).timeout
		# inimigo age
		await get_tree().create_timer(1.0).timeout
		next_turn()
		
func player_action (action : Action):
	if current_character != player_character:
		return
	player_character.act(action, ai_character)
	# desativar interface do jogador
	await get_tree().create_timer(1.0).timeout
	next_turn()
	
func ai_decide_action ():
	pass
