extends Control

var cooldown := 1.0
var em_cooldown := false

func _ready():
	conectar_botoes_recursivamente(self)

func conectar_botoes_recursivamente(no: Node):
	for child in no.get_children():
		if child is Button:
			child.pressed.connect(func(): tentar_mostrar_descricao(child))
		else:
			conectar_botoes_recursivamente(child)

func tentar_mostrar_descricao(botao: Button):
	if em_cooldown:
		return

	em_cooldown = true
	mostrar_descricao(botao)
	await get_tree().create_timer(cooldown).timeout
	em_cooldown = false

func mostrar_descricao(botao: Button):
	# A label deve estar como irmão ou filho do botão
	var label := botao.get_parent().get_node_or_null("Label")
	if label:
		label.show()
		await get_tree().create_timer(2.0).timeout
		label.hide()
