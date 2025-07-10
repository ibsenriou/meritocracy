extends Control

# --- CENAS DOS POPUPS ---
@onready var cena_loja: PackedScene = preload("res://Scene/popups/tela_loja.tscn")
@onready var cena_inventario: PackedScene = preload("res://Scene/popups/tela_inventario.tscn")
@onready var cena_opcoes: PackedScene = preload("res://Scene/popups/TelaOpcoes.tscn")

# --- UI ---
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel  # Label que mostra mês, ano e idade
@onready var dinheiro_label: Label = $TopoHUD/DinheiroLabel  # Label que mostra o dinheiro

# --- BOTÕES ---
@onready var botao_inventario: Button = $BotoesInferiores/HBoxContainer/BotaoInventario
@onready var botao_loja: Button = $BotoesInferiores/HBoxContainer/BotaoLoja
@onready var botao_opcoes: TextureButton = $TopoHUD/BotaoOpcoes
@onready var botao_passar_mes: Button = $PersonagemArea/BotaoPassarMes

# --- POPUPS / TELAS ---
@onready var tela_ativa: Control = $TelaAtiva  # Nó onde as telas aparecem
var tela_atual: Node = null  # Referência para a tela popup atual

# --- ESTADO DO JOGO ---
var mes_atual: int = 1
var ano_atual: int = 79
var idade: int = 18
var dinheiro: float = 0.0

# Lista com os nomes dos meses para mostrar abreviado
var nomes_meses = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]

func _ready():
	# Conecta sinais dos botões para funções específicas
	botao_loja.pressed.connect(_on_botao_loja_pressed)
	botao_inventario.pressed.connect(_on_botao_inventario_pressed)
	botao_opcoes.pressed.connect(_on_botao_opcoes_pressed)
	botao_passar_mes.pressed.connect(_on_botao_passar_mes_pressed)

	# Atualiza os labels da HUD com os valores iniciais
	atualizar_status()

# Função para abrir uma tela popup
func abrir_tela(cena: PackedScene):
	# Se já tem uma tela aberta
	if tela_atual and tela_atual.is_inside_tree():
		# Se for a mesma tela, fecha ela e mostra botão passar mês
		if tela_atual.scene_file_path == cena.resource_path:
			tela_atual.queue_free()
			tela_atual = null
			botao_passar_mes.show()
			return
		else:
			# Se for outra tela, fecha a atual
			tela_atual.queue_free()
			tela_atual = null

	# Esconde o botão passar mês enquanto popup estiver ativo
	botao_passar_mes.hide()

	# Instancia e adiciona a nova tela popup na cena
	tela_atual = cena.instantiate()
	tela_ativa.add_child(tela_atual)

	# Centraliza o popup na área disponível
	await get_tree().process_frame
	var area = tela_ativa.get_size()
	tela_atual.position = area / 2 - tela_atual.size / 2

# Funções chamadas quando cada botão é pressionado:
func _on_botao_loja_pressed():
	abrir_tela(cena_loja)

func _on_botao_inventario_pressed():
	abrir_tela(cena_inventario)

func _on_botao_opcoes_pressed():
	abrir_tela(cena_opcoes)

# Função para avançar o mês e calcular dinheiro
func _on_botao_passar_mes_pressed():
	dinheiro += 100  # Exemplo fixo de dinheiro ganho

	mes_atual += 1

	if mes_atual > 12:
		mes_atual = 1
		ano_atual += 1
		idade += 1

		# Quando a idade chegar a 80, reinicia para nova geração
		if idade >= 80:
			print("🔁 Nova geração iniciada!")
			idade = 18
			ano_atual = 1
			mes_atual = 1

	# Atualiza a HUD para refletir as mudanças
	atualizar_status()

# Atualiza os textos na HUD
func atualizar_status():
	var mes_texto = nomes_meses[(mes_atual - 1) % 12]  # Ajusta índice para lista zero-based
	mes_ano_label.text = "%s/Ano %02d - Idade %d anos" % [mes_texto, ano_atual, idade]
	dinheiro_label.text = "R$ %.2f" % dinheiro
