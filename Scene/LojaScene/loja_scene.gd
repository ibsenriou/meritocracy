extends Control

@onready var botao_comprar_valor: Button = $CanvasLayer/ScrollContainer/MarginContainer/VBoxContainer/ItemCursoBasico/BotaoComprarValor
@onready var conta_corrente_label: Label = $TopoHUD/ContaCorrenteLabel
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel
@onready var botao_loja: TextureButton = $HBoxContainer/BotaoLoja


func _ready():
	botao_loja.pressed.connect(_on_botao_loja_pressed)
	
	#Atualiza os valores da interface sempre que a loja abrir
	_atualizar_interface()

func _on_botao_loja_pressed():
		## já está na Loja → volta pra Main
	get_tree().change_scene_to_file("res://Scene/MainScene/main_scene.tscn")
	

	
func _atualizar_interface():
	conta_corrente_label.text = "R$ " + str(Global.dinheiro)
	mes_ano_label.text = str(Global.mes) + "/" + str(Global.ano)
	
	# Atualiza o texto do botão com o preço real vindo do Global
	var preco = Global.get_price("curso_basico")
	botao_comprar_valor.text = "R$ " + str(preco)

	# Conecta a ação de compra
	botao_comprar_valor.pressed.connect(_on_botao_comprar_valor_pressed)

func _on_botao_comprar_valor_pressed():
	var item_id = "curso_basico"
	if Global.buy_item(item_id):
		print("✅ Compra bem-sucedida! Dinheiro:", Global.dinheiro, "Salário:", Global.salario)
		
	else:
		print("❌ Sem dinheiro suficiente para comprar o curso básico.")
