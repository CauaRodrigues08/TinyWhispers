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

var characters = {}
var turn_order = []
var current_turn_index = 0
var enemy_id_to_load: String = "1001"

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

	ActionsButton.pressed.connect(_on_ActionsButton_pressed)
	soco_button.pressed.connect(func(): _on_action_button_pressed("Pedro", "2003", "Boss"))
	careta_button.pressed.connect(func(): _on_action_button_pressed("Pedro", "2004", "Boss"))
	espada_button.pressed.connect(func(): _on_action_button_pressed("Levi", "2005", "Boss"))
	ponto_fraco_button.pressed.connect(func(): _on_action_button_pressed("Levi", "2006", "Boss"))
	arremesso_button.pressed.connect(func(): _on_action_button_pressed("Luis", "2001", "Boss"))
	arremesso_triplo_button.pressed.connect(func(): _on_action_button_pressed("Luis", "2002", "Boss"))
	abraço_button.pressed.connect(func(): _on_action_button_pressed("Sophia", "2007", "Pedro")) # Ex: cura Pedro
	abraço_grupo_button.pressed.connect(func(): _on_action_button_pressed("Sophia", "2008", "")) # Cura em grupo

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

	update_ui()

func create_character(data: Dictionary) -> Node:
	var c = Character.new()
	c.setup(data)
	return c

func setup_turn_order():
	turn_order = ["Pedro", "Levi", "Luis", "Sophia", "Boss"]

# SISTEMA DE TTURNOS

func start_turn():
	var current_name = turn_order[current_turn_index]
	var current = characters[current_name]
	
	show_ui_for(current_name)

	if current.type == GameData.TYPE_PLAYER:
		show_player_actions(current_name)
	else:
		ActionsContainer.hide()
		await get_tree().create_timer(1.0).timeout
		execute_enemy_turn(current)
		end_turn()

func end_turn():
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

func execute_enemy_turn(enemy: Character):
	var action_id = enemy.actions[randi() % enemy.actions.size()]
	var action_data = GameData.ACTIONS.filter(func(a): return a.id == action_id)[0]

	var targets = []
	if action_data.target.scope == GameData.TARGET_ALL:
		targets = ["Pedro", "Levi", "Luis", "Sophia"]
	else:
		targets = [turn_order[randi() % 4]] 

	for t in targets:
		apply_action(enemy.character_name, action_id, t)

# INTERFINTERFACE DE BATALHA

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
var personagemDoTurno: String
func show_player_actions(character_name: String):
	hide_all_actions()
	personagemDoTurno = character_name
func  _on_ActionsButton_pressed():
	match personagemDoTurno:
		"Pedro":
			pedro_actions.show()
		"Levi":
			levi_actions.show()
		"Luis":
			luis_actions.show()
		"Sophia":
			sophia_actions.show()

	ActionsContainer.show()
	show_ui_for(personagemDoTurno)

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
	pedro_nome.text = pedro.character_name
	pedro_vida_numero.text = "%d/%d" % [pedro.current_hp, pedro.max_hp]

	var levi = characters["Levi"]
	lifebar_levi.max_value = levi.max_hp
	lifebar_levi.value = levi.current_hp
	levi_nome.text = levi.character_name
	levi_vida_numero.text = "%d/%d" % [levi.current_hp, levi.max_hp]

	var luis = characters["Luis"]
	lifebar_luis.max_value = luis.max_hp
	lifebar_luis.value = luis.current_hp
	luis_nome.text = luis.character_name
	luis_vida_numero.text = "%d/%d" % [luis.current_hp, luis.max_hp]

	var sophia = characters["Sophia"]
	lifebar_sophia.max_value = sophia.max_hp
	lifebar_sophia.value = sophia.current_hp
	sophia_nome.text = sophia.character_name
	sophia_vida_numero.text = "%d/%d" % [sophia.current_hp, sophia.max_hp]

	var b = characters["Boss"]
	lifebar_boss.max_value = b.max_hp
	lifebar_boss.value = b.current_hp
	boss_nome.text = b.character_name
	boss_vida_numero.text = "%d/%d" % [b.current_hp, b.max_hp]

# OUTROS BOTÕES
# As funções desses botões ainda serão implementadas

func _on_itens_button_pressed():
	ActionsContainer.hide()
	# Implementar lógica de inventário

func _on_surrender_button_pressed():
	ActionsContainer.hide()
	# Retornar ao salão ou menu
