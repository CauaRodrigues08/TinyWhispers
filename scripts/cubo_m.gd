extends Button

@onready var label = $"../cuboM_texto"

func _ready():
	label.visible = false
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	disabled = true
	label.visible = true
	await get_tree().create_timer(2.0).timeout
	label.visible = false
	disabled = false
