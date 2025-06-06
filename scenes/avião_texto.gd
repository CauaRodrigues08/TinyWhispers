extends Label

func _ready():
	text = "Hieeeoon~ Levi está segurando um avião!"
	visible = false

	add_theme_color_override("font_color", Color.WHITE)

	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
