extends Resource
class_name Action

@export var name: String
@export var description: String
@export var target_type: Target_type

enum Target_type {ENEMIES, PLAYERS}
