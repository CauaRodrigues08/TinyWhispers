extends Node
class_name TurnBasedAgent

signal target_selected(target: TurnBasedAgent, command: Resource)
signal undo_command_selected()
signal turn_finished()
signal player_turn_started()

@onready var onTurnIcon: TextureRect = $onTurnIcon
@onready var targetIcon: TextureRect = $targetIcon

@export var character_type : Character_Type
@export var onTurnIconOffset: Vector2 = Vector2(0, -50)
@export var targetIconOffset: Vector2 = Vector2(50, 0)


enum Character_Type {PLAYER, ENEMY}

@export var isActive := false
var selectedCommand: Resource
var target: TurnBasedAgent

func get_global_position():
	return get_parent().global_position

func command_done():
	turn_finished.emit()

func _input(event: InputEvent) -> void:
	if not target: return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	var players = get_tree().get_nodes_in_group("player")
	
	if target in enemies: _select_between_targets(event, enemies)
	else: _select_between_targets(event, players)
	
	if event.is_action_pressed("ui_accept"): _select_target()
	elif event.is_action_pressed("ui_cancel"): _undo_command()

func _undo_command():
	target = null
	_deselect_all_targets()
	undo_command_selected.emit()
	
func _select_target():
	target_selected.emit(target, selectedCommand)
	_deselect_all_targets()
	set_active(false)
	target = null
	
func set_active(boolean: bool):
	isActive = boolean
	if isActive: onTurnIcon.show()
	else: onTurnIcon.hide()

func _select_between_targets(event: InputEvent, targets: Array):
	var currentTargetIndex = targets.find(target, 0)
	
	var goLeft = event.is_action_pressed("ui_left")
	var goRight = event.is_action_pressed("ui_right")
	
	if not goLeft and not goRight: return
	
	if goLeft:
		currentTargetIndex -= 1
		if currentTargetIndex < 0: currentTargetIndex = targets.size() - 1
	elif goRight:
		currentTargetIndex += 1
		if currentTargetIndex > targets.size() - 1: currentTargetIndex = 0
	
	_deselect_all_targets()
	target = targets[currentTargetIndex]
	target.set_target()
	
func _deselect_all_targets():
	var allTargets = get_tree().get_nodes_in_group("enemy") + get_tree().get_nodes_in_group("player")
	
	for target in allTargets:
		target.target_icon_node.hide()	

func _ready() -> void:
	_set_group()
	_set_on_turn_icon()
	_set_target_icon()
	
	_set_late_signals()

func _set_group():
	if character_type == Character_Type.PLAYER:
		add_to_group("player")
	elif character_type == Character_Type.ENEMY:
		add_to_group("enemy")

func _set_on_turn_icon():
	onTurnIcon.hide()
	onTurnIcon.global_position = get_parent().global_position - (onTurnIcon.get_global_rect().size / 2) + onTurnIconOffset

func _set_target_icon():
	targetIcon.hide()
	targetIcon.global_position = get_parent().global_position - (targetIcon.get_global_rect().size/2) + targetIconOffset
	
	if character_type == Character_Type.ENEMY: targetIcon.modulate = Color(1,0,0)
	elif character_type == Character_Type.PLAYER: targetIcon.modulate = Color(0, 1, 0)

func _set_late_signals():
	await get_tree().current_scene.ready
	
	var commandMenu: CommandMenu = get_tree().get_first_node_in_group("commandMenu")
	commandMenu.command_selected.connect(_on_command_selected)

func _on_command_selected(command: Resource):
	if not isActive: return
	
	selectedCommand = command
	
	if command.targetType == Action.Target_type.ENEMIES:
		target = get_tree().get_first_node_in_group("enemy")
	elif command.targetType == Action.Target_type.PLAYERS:
		target = get_tree().get_first_node_in_group("player")
	
	target.set_target()

func set_target():
	targetIcon.show()
