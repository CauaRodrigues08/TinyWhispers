extends Label

func _ready():
	text = "É uma bola!"
	visible = false  # Começa invisível

	# Texto branco
	add_theme_color_override("font_color", Color.WHITE)

	# Centraliza o texto
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
