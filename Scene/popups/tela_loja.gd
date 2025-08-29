extends Control  # anexado à TelaLoja

var precos = {
	"Item1": 150000,
	"Item2": 2500,
	"Item3": 1000000,
	"Item4": 9550000,
	"Item5": 10003000,
	"Item6": 1000777,
	"Item7": 1105000,
	"Item8": 1000500,
}

var dinheiro_atual = 500000

func _ready():
	# Adiar para garantir que todos os filhos existam
	call_deferred("_inicializar_itens")

func _inicializar_itens():
	var vbox = _procurar_vbox(self)
	if vbox == null:
		print("VBoxContainer não encontrado!")
		return

	for item_hbox in vbox.get_children():
		if item_hbox is HBoxContainer:
			for child in item_hbox.get_children():
				if child is Label and child.name.begins_with("LabelValor"):
					if precos.has(item_hbox.name):
						child.text = formatar_valor(precos[item_hbox.name])
					else:
						child.text = "Sem preço"

# Função recursiva para procurar VBoxContainer
func _procurar_vbox(node: Node) -> VBoxContainer:
	if node is VBoxContainer:
		return node
	for child in node.get_children():
		var resultado = _procurar_vbox(child)
		if resultado != null:
			return resultado
	return null

# Compra de item
func comprar_item(item_name: String):
	if not precos.has(item_name):
		print("Item não encontrado!")
		return

	var preco = precos[item_name]
	if dinheiro_atual >= preco:
		dinheiro_atual -= preco
		print("Comprou ", item_name, " por ", preco, " | Dinheiro restante: ", dinheiro_atual)
		_atualizar_label_item(item_name)
	else:
		print("Dinheiro insuficiente!")

func _atualizar_label_item(item_name):
	var vbox = _procurar_vbox(self)
	if vbox == null:
		return

	for item_hbox in vbox.get_children():
		if item_hbox.name == item_name:
			for child in item_hbox.get_children():
				if child is Label and child.name.begins_with("LabelValor"):
					child.text = formatar_valor(precos[item_name])

func formatar_valor(value: int) -> String:
	if value >= 1000000:
		var v = round((value / 1000000.0) * 100) / 100.0
		return str(v).rstrip("0").rstrip(".") + "mi"
	elif value >= 1000:
		var v = round((value / 1000.0) * 100) / 100.0
		return str(v).rstrip("0").rstrip(".") + "k"
	return str(value)
