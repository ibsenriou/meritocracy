extends Control

@onready var botao_comprar_valor: Button = $CanvasLayer/ScrollContainer/MarginContainer/VBoxContainer/ItemCursoBasico/BotaoComprarValor
@onready var conta_corrente_label: Label = $TopoHUD/ContaCorrenteLabel
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel
@onready var botao_loja: TextureButton = $HBoxContainer/BotaoLoja

const Utils = preload("res://Scene/Scripts/Utils.gd") ## Utils script importado pois não é um autoload
# Autoload são classes usando o padrão Singleton, são classes que instanciam um único objeto imediatamente quando importada
# Como o utils usará apenas métodos estáticos para organização do código, você nao precisar instanciar uma classe utils()
# apenas chamar Utils.format_money e não preciasa usar var utils = new Utils() e entao utils.format_money().


func _ready():
	MusicManager.play_music("store")
	botao_loja.pressed.connect(_on_botao_loja_pressed)
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	
	#Atualiza os valores da interface sempre que a loja abrir
	_atualizar_cabecalho_de_status()

func _on_botao_loja_pressed():
		## já está na Loja → volta pra Main
	get_tree().change_scene_to_file("res://Scene/MainScene/main_scene.tscn")
	

func _on_money_changed(new_value):
	conta_corrente_label.text = "R$ " + Utils.format_money(int(new_value))
	
func _atualizar_cabecalho_de_status():
	mes_ano_label.text = "Tempo Atual: " + str(Global.time)
	conta_corrente_label.text = "R$ " + Utils.format_money(int(Global.money))

	
	# Atualiza o texto do botão com o preço real vindo do Global
	var preco = Global.get_price("curso_basico")
	botao_comprar_valor.text = "R$ " + str(preco)

	# Conecta a ação de compra
	botao_comprar_valor.pressed.connect(_on_botao_comprar_valor_pressed)

func _on_botao_comprar_valor_pressed():
	var item_id = "curso_basico"
	if Global.buy_item(item_id):
		print("✅ Compra bem-sucedida! Dinheiro: ", Global.money, " & Salário: ", Global.salary)
		
	else:
		print("❌ Sem dinheiro suficiente para comprar o curso básico.")
