extends Control

@onready var label_tempo = $Cabeçalho/LabelTempo
@onready var label_dinheiro = $Cabeçalho/LabelDinheiro
@onready var botao_opcoes = $Cabeçalho/BotaoOpcoes

@onready var tela_ativa = $TelaAtiva

@onready var botao_main = $Rodape/BotaoMain
@onready var botao_loja = $Rodape/BotaoLoja
@onready var botao_inventario = $Rodape/BotaoInventario
@onready var botao_upgrade = $Rodape/BotaoUpgrade
@onready var botao_extra = $Rodape/BotaoExtra

func _ready():
	atualizar_hud()
	conectar_botoes()

func atualizar_hud():
	# Aqui você coloca a lógica real de tempo e dinheiro do seu jogo
	label_tempo.text = "Mês 1 / Ano 1"
	label_dinheiro.text = "0"

func conectar_botoes():
	botao_main.pressed.connect(_on_botao_main)
	botao_loja.pressed.connect(_on_botao_loja)
	botao_inventario.pressed.connect(_on_botao_inventario)
	botao_upgrade.pressed.connect(_on_botao_upgrade)
	botao_extra.pressed.connect(_on_botao_extra)

# ---- Callbacks para trocar de tela ----
func _on_botao_main():
	get_tree().change_scene_to_file("res://cenas/TelaMain.tscn")

func _on_botao_loja():
	get_tree().change_scene_to_file("res://cenas/TelaLoja.tscn")

func _on_botao_inventario():
	get_tree().change_scene_to_file("res://cenas/TelaInventario.tscn")

func _on_botao_upgrade():
	get_tree().change_scene_to_file("res://cenas/TelaUpgrade.tscn")

func _on_botao_extra():
	get_tree().change_scene_to_file("res://cenas/TelaExtra.tscn")
