extends CanvasLayer
class_name CommandMenu

signal command_selected(command: Resource)

@onready var actionButton = %"AçõesButton"
@onready var itemButton = %ItensButton
@onready var menuButton = %MenuButton
@onready var attackButton = %AttackButton
@onready var healButton = %HealButton
@onready var voltarButton = %VoltarButton

@onready var commandsContainer = %"BotõesBatalha"
@onready var actionsContainer = %"AçõesContainer"

const ATTACK = preload("res://actions/attacks/light_attack.tres")
const HEAL = preload("res://actions/buffs/heal.tres")

func _ready() -> void:
	add_to_group("commandMenu")
	
	attackButton.pressed.connect(_on_command_pressed.bind(ATTACK))
	healButton.pressed.connect(_on_command_pressed.bind(HEAL))
	actionButton.pressed.connect(_on_actions_button_pressed)
	voltarButton.pressed.connect(_on_voltar_button_pressed)
	
func _on_command_pressed(command: Resource):
	command_selected.emit(command)
	commandsContainer.show()
	actionsContainer.hide()
	
func _on_actions_button_pressed():
	commandsContainer.hide()
	actionsContainer.show()
	
func _on_voltar_button_pressed():
	actionsContainer.hide()
	commandsContainer.show()
