extends Label

func _ready():
	text = "Vai Sophia! Você está quase pegando o cubo!"
	visible = false

	add_theme_color_override("font_color", Color.WHITE)

	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
