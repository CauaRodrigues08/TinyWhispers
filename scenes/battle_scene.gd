extends Node2D

@onready var ActionsContainer = $UI_Batalha/UIBackground/ContentBox/ActionsContainer
@onready var Action1Button = $UI_Batalha/UIBackground/ContentBox/ActionsContainer/Action1Button
@onready var Action2Button = $UI_Batalha/UIBackground/ContentBox/ActionsContainer/Action2Button
@onready var ActionsButton = $UI_Batalha/UIBackground/HBoxContainer/Action_button

func _ready() -> void:
	ActionsContainer.hide()
	
	ActionsButton.pressed.connect(_on_ActionsButton_pressed)
	Action1Button.pressed.connect(_on_ActionButton_pressed)
	Action2Button.pressed.connect(_on_ActionButton_pressed)
	
func show_actions_buttons() -> void:
	ActionsContainer.show()
	
func hide_actions_buttons() -> void:
	ActionsContainer.hide()
	
func _on_ActionsButton_pressed() -> void:
	show_actions_buttons()

func _on_ActionButton_pressed() -> void:
	hide_actions_buttons()
