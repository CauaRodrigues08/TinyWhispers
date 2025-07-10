# NOTAS:
# O código não é nada escalável, sendo altamente específico aos dados existentes no jogo. Futuramente há a possibilidade de alterações para deicar o código menos dependente dos dados.

extends Node

@onready var ActionsContainer = %ActionsContainer

@onready var pedro_actions = %PedroActions
@onready var soco_button = %SocoButton
@onready var careta_button = %CaretaButton

@onready var levi_actions: HBoxContainer = %LeviActions
@onready var espada_button: Button = %EspadaButton
@onready var ponto_fraco_button: Button = %PontoFracoButton

@onready var luis_actions: HBoxContainer = %LuisActions
@onready var arremesso_button: Button = %ArremessoButton
@onready var arremesso_triplo_button: Button = %ArremessoTriploButton

@onready var sophia_actions: HBoxContainer = %SophiaActions
@onready var abraço_button: Button = %AbraçoButton
@onready var abraço_grupo_button: Button = %AbraçoGrupoButton

@onready var heal_container: HBoxContainer = %HealContainer
@onready var sophia_heal: Button = %SophiaHeal
@onready var luis_heal: Button = %LuisHeal
@onready var levi_heal: Button = %LeviHeal
@onready var pedro_heal: Button = %PedroHeal

@onready var ActionsButton = %Action_button
@onready var itens_button: Button = %Itens_button
@onready var surrender_button: Button = %Surrender_button

@onready var lifebar_pedro: TextureProgressBar = %lifebar_Pedro
@onready var pedro_nome: Label = %PedroNome
@onready var pedro_vida_numero: Label = %PedroVidaNumero

@onready var lifebar_levi: TextureProgressBar = %lifebar_Levi
@onready var levi_nome: Label = %LeviNome
@onready var levi_vida_numero: Label = %LeviVidaNumero

@onready var lifebar_sophia: TextureProgressBar = %lifebar_Sophia
@onready var sophia_nome: Label = %SophiaNome
@onready var sophia_vida_numero: Label = %SophiaVidaNumero

@onready var lifebar_luis: TextureProgressBar = %lifebar_Luís
@onready var luis_nome: Label = %LuisNome
@onready var luis_vida_numero: Label = %LuisVidaNumero

@onready var lifebar_boss: TextureProgressBar = %Lifebar_Boss
@onready var boss_nome: Label = %BossNome
@onready var boss_vida_numero: Label = %BossVidaNumero

@onready var enemy_group: Node2D = %Enemy_Group

@onready var background: Sprite2D = $"../Background"

@onready var fight_end_container: HBoxContainer = %FightEndContainer
@onready var next_fight_button: Button = %NextFightButton

var characters = {}
var turn_order = []
var current_turn_index = 0
var enemy_id_to_load: String = BattleData.current_enemy_id
var fight_ended := false

func _ready():
	setup_ui()
	instantiate_characters()
	setup_turn_order()
	start_turn()

func setup_ui():
	ActionsContainer.hide()
	pedro_actions.hide()
	levi_actions.hide()
	luis_actions.hide()
	sophia_actions.hide()
	heal_container.hide()

	ActionsButton.pressed.connect(_on_ActionsButton_pressed)
	
	soco_button.pressed.connect(func(): _on_action_button_pressed("Pedro", "2003", "Boss"))
	careta_button.pressed.connect(func(): _on_action_button_pressed("Pedro", "2004", "Boss"))
	espada_button.pressed.connect(func(): _on_action_button_pressed("Levi", "2005", "Boss"))
	ponto_fraco_button.pressed.connect(func(): _on_action_button_pressed("Levi", "2006", "Boss"))
	arremesso_button.pressed.connect(func(): _on_action_button_pressed("Luis", "2001", "Boss"))
	arremesso_triplo_button.pressed.connect(func(): _on_action_button_pressed("Luis", "2002", "Boss"))
	abraço_button.pressed.connect(_on_abraço_button_pressed) 
	abraço_grupo_button.pressed.connect(func(): _on_action_button_pressed("Sophia", "2008", ""))
	
	
	sophia_heal.pressed.connect(func(): _on_heal_button_pressed("Sophia"))
	luis_heal.pressed.connect(func(): _on_heal_button_pressed("Luis"))
	levi_heal.pressed.connect(func(): _on_heal_button_pressed("Levi"))
	pedro_heal.pressed.connect(func(): _on_heal_button_pressed("Pedro"))

	itens_button.pressed.connect(_on_itens_button_pressed)
	surrender_button.pressed.connect(_on_surrender_button_pressed)

func instantiate_characters():
	var pd = GameData.CHARACTERS[3]
	var lv = GameData.CHARACTERS[2]
	var ls = GameData.CHARACTERS[0]
	var sp = GameData.CHARACTERS[1]
	var bs = GameData.ENEMIES.filter(func(e): return e.id == enemy_id_to_load)[0]

	characters["Pedro"] = create_character(pd)
	characters["Levi"] = create_character(lv)
	characters["Luis"] = create_character(ls)
	characters["Sophia"] = create_character(sp)
	characters["Boss"] = create_character(bs)
	
	var enemy_scene = preload("res://scenes/enemy.tscn")
	var enemy_instance = enemy_scene.instantiate()
	
	var enemy_sprite = enemy_instance.get_node("Sprite")
	enemy_sprite.texture = bs.texture
	
	enemy_group.add_child(enemy_instance)
	set_enemy_background(bs)

	update_ui()
	
func set_enemy_background(enemy_data : Dictionary) -> void: 
	var default_background_path = load("res://images/Room-Perspective.svg")
	
	var background_path : String = "res://images/%s.png" % enemy_data.id
	var texture : Texture = load(background_path)
	
	if texture == null:
		print("No specific background found for enemy. Loading default background.")
		texture = default_background_path
		
	background.texture = texture

func create_character(data: Dictionary) -> Node:
	var c = Character.new()
	c.setup(data)
	return c

func setup_turn_order():
	turn_order = ["Pedro", "Levi", "Luis", "Sophia", "Boss"]

# SISTEMA DE TURNOS

func start_turn():
	if fight_ended:
		return
	
	var current_name = turn_order[current_turn_index]
	var current = characters[current_name]
	
	if current.current_hp <= 0:
		end_turn()
		return
	
	show_ui_for(current_name)
	
	if GameData.BUFF_PARALYZED in current.status_effects:
		current.status_effects.erase(GameData.BUFF_PARALYZED)
		end_turn()
		return

	if current.type == GameData.TYPE_PLAYER:
		show_player_actions(current_name)
	else:
		ActionsContainer.hide()
		await get_tree().create_timer(1.0).timeout
		execute_enemy_turn(current)
		end_turn()

func end_turn():
	if fight_ended:
		return
	hide_all_actions()
	current_turn_index = (current_turn_index + 1) % turn_order.size()
	await get_tree().create_timer(1.0).timeout
	start_turn()

# EXECUÇÃO DE AÇÕES

func _on_action_button_pressed(user_name: String, action_id: String, target_name: String):
	if target_name == "":
		if action_id == "2008": # Abraço em grupo
			for character in ["Pedro", "Levi", "Luis", "Sophia"]:
				apply_action(user_name, action_id, character)
	else:
		apply_action(user_name, action_id, target_name)
	ActionsContainer.hide()
	end_turn()

func apply_action(user_name: String, action_id: String, target_name: String):
	var target = characters[target_name]
	var action_data = GameData.ACTIONS.filter(func(a): return a.id == action_id)[0]

	match action_data.type:
		GameData.TYPE_ATTACK:
			var total = action_data.amount * action_data.hits
			target.current_hp = max(0, target.current_hp - total)
		GameData.TYPE_HEAL:
			var total = action_data.amount
			target.current_hp = min(target.max_hp, target.current_hp + total)
		GameData.TYPE_BUFF:
			target.status_effects.append(action_data.buff)

	update_ui()
	
	if target.current_hp <= 0 and target_name == "Boss":
		end_fight()

func execute_enemy_turn(enemy: Character):
	var action_id = enemy.actions[randi() % enemy.actions.size()]
	var action_data = GameData.ACTIONS.filter(func(a): return a.id == action_id)[0]

	var targets: Array = []

	if action_data.target.side == GameData.SIDE_PLAYER:
		
		if action_data.target.scope == GameData.TARGET_ALL:
			targets = ["Pedro", "Levi", "Luis", "Sophia"]
		else:
			if GameData.BUFF_TAUNTED in enemy.status_effects:
				targets = ["Pedro"]
			else:
				
				var alive_players = ["Pedro", "Levi", "Luis", "Sophia"].filter(
					func(p): return characters[p].current_hp > 0
				)
				if alive_players.size() > 0:
					targets = [alive_players[randi() % alive_players.size()]]
	elif action_data.target.side == GameData.SIDE_ENEMY:
		# 
		if action_data.target.scope == GameData.TARGET_ALL:
			targets = ["Boss"]  # Caso adicionemos mais inimigos
		else:
			targets = ["Boss"] 

	for t in targets:
		apply_action(enemy.character_name, action_id, t)

	if GameData.BUFF_TAUNTED in enemy.status_effects:
		enemy.status_effects.erase(GameData.BUFF_TAUNTED)

	
func _on_heal_button_pressed(target_name: String):
	apply_action("Sophia", "2007", target_name)
	heal_container.hide()
	end_turn()
	
func end_fight():
	fight_ended = true
	hide_all_actions()
	ActionsContainer.hide()
	fight_end_container.show()

# INTERFACE DE BATALHA

func _on_abraço_button_pressed():
	sophia_actions.hide()
	heal_container.show()
	update_heal_buttons()

func show_ui_for(character_name: String):
	
	lifebar_pedro.hide()
	pedro_nome.hide()
	pedro_vida_numero.hide()

	lifebar_levi.hide()
	levi_nome.hide()
	levi_vida_numero.hide()

	lifebar_luis.hide()
	luis_nome.hide()
	luis_vida_numero.hide()

	lifebar_sophia.hide()
	sophia_nome.hide()
	sophia_vida_numero.hide()

	match character_name:
		"Pedro":
			lifebar_pedro.show()
			pedro_nome.show()
			pedro_vida_numero.show()
		"Levi":
			lifebar_levi.show()
			levi_nome.show()
			levi_vida_numero.show()
		"Luis":
			lifebar_luis.show()
			luis_nome.show()
			luis_vida_numero.show()
		"Sophia":
			lifebar_sophia.show()
			sophia_nome.show()
			sophia_vida_numero.show()
		"Boss":
			lifebar_boss.show()
			boss_nome.show()
			boss_vida_numero.show()
		
	if character_name == "Boss" and characters["Boss"].current_hp <= 0:
		lifebar_boss.hide()
		boss_nome.hide()
		boss_vida_numero.hide()

func show_player_actions(character_name: String):
	hide_all_actions()
	match character_name:
		"Pedro":
			pedro_actions.show()
		"Levi":
			levi_actions.show()
		"Luis":
			luis_actions.show()
		"Sophia":
			sophia_actions.show()

	ActionsContainer.show()
	show_ui_for(character_name)

func hide_all_actions():
	pedro_actions.hide()
	levi_actions.hide()
	luis_actions.hide()
	sophia_actions.hide()
	ActionsContainer.hide()

func update_ui():
	var pedro = characters["Pedro"]
	lifebar_pedro.max_value = pedro.max_hp
	lifebar_pedro.value = pedro.current_hp
	pedro_nome.text = pedro.character_name.to_upper()
	pedro_vida_numero.text = "%d/%d" % [pedro.current_hp, pedro.max_hp]

	var levi = characters["Levi"]
	lifebar_levi.max_value = levi.max_hp
	lifebar_levi.value = levi.current_hp
	levi_nome.text = levi.character_name.to_upper()
	levi_vida_numero.text = "%d/%d" % [levi.current_hp, levi.max_hp]

	var luis = characters["Luis"]
	lifebar_luis.max_value = luis.max_hp
	lifebar_luis.value = luis.current_hp
	luis_nome.text = luis.character_name.to_upper()
	luis_vida_numero.text = "%d/%d" % [luis.current_hp, luis.max_hp]

	var sophia = characters["Sophia"]
	lifebar_sophia.max_value = sophia.max_hp
	lifebar_sophia.value = sophia.current_hp
	sophia_nome.text = sophia.character_name.to_upper()
	sophia_vida_numero.text = "%d/%d" % [sophia.current_hp, sophia.max_hp]

	var b = characters["Boss"]
	lifebar_boss.max_value = b.max_hp
	lifebar_boss.value = b.current_hp
	boss_nome.text = b.character_name.to_upper()
	boss_vida_numero.text = "%d/%d" % [b.current_hp, b.max_hp]
	
	update_heal_buttons()

func _on_ActionsButton_pressed():
	heal_container.hide()
	hide_all_actions() 
	show_player_actions(turn_order[current_turn_index])

func update_heal_buttons():
	sophia_heal.text = "%d/%d" % [characters["Sophia"].current_hp, characters["Sophia"].max_hp]
	luis_heal.text = "%d/%d" % [characters["Luis"].current_hp, characters["Luis"].max_hp]
	levi_heal.text = "%d/%d" % [characters["Levi"].current_hp, characters["Levi"].max_hp]
	pedro_heal.text = "%d/%d" % [characters["Pedro"].current_hp, characters["Pedro"].max_hp]
	

# OUTROS BOTÕES
# As funções desses botões ainda serão implementadas

func _on_itens_button_pressed():
	ActionsContainer.hide()
	# Implementar lógica de inventário

func _on_surrender_button_pressed():
	ActionsContainer.hide()
	# Retornar ao salão ou menu
