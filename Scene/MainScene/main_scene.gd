extends Control

# --- CENAS DOS POPUPS ---
@onready var cena_loja: PackedScene = preload("res://Scene/popups/tela_loja.tscn")
@onready var cena_inventario: PackedScene = preload("res://Scene/popups/tela_inventario.tscn")
@onready var cena_opcoes: PackedScene = preload("res://Scene/popups/TelaOpcoes.tscn")
@onready var cena_c: PackedScene = preload("res://Scene/popups/tela_c.tscn")
@onready var cena_d: PackedScene = preload("res://Scene/popups/tela_d.tscn")
@onready var cena_e: PackedScene = preload("res://Scene/popups/tela_e.tscn")

# --- UI ---
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel  # Label que mostra mês, ano e idade
@onready var conta_corrente_label: Label = $TopoHUD/ContaCorrenteLabel# Label que mostra a conta corrente

# --- BOTÕES ---
@onready var botao_inventario: TextureButton = $BotoesInferiores/HBoxContainer/BotaoInventario
@onready var botao_loja: TextureButton = $BotoesInferiores/HBoxContainer/BotaoLoja
@onready var botao_opcoes: TextureButton = $TopoHUD/BotaoOpcoes
@onready var botao_passar_mes: TextureButton = $BotaoPassarMes
@onready var botao_d: TextureButton = $BotoesInferiores/HBoxContainer/BotaoD
@onready var botao_e: TextureButton = $BotoesInferiores/HBoxContainer/BotaoE
@onready var botao_status: TextureButton = $BotoesInferiores/HBoxContainer/BotaoStatus


# --- POPUPS / TELAS ---
@onready var tela_ativa: Control = $TelaAtiva  # Nó onde as telas aparecem
var tela_atual: Node = null  # Referência para a tela popup atual

# --- ESTADO DO JOGO ---
var mes_atual: int = 1
var ano_atual: int = 79
var idade: int = 79
var conta_corrente: float = 0.0

func _ready():
	# Chama a funcao para iniciar o jogo com a lógica centralizada nela
	_iniciar_jogo()
	
# Funções chamadas quando cada botão é pressionado:
func _on_botao_loja_pressed():
	print("Botão funcionando!")
	_abrir_cena_como_popup(cena_loja)

func _on_botao_inventario_pressed():
	_abrir_cena_como_popup(cena_inventario)

func _on_botao_opcoes_pressed():
	_abrir_cena_como_popup(cena_opcoes)
	
func _on_botao_status_pressed():
	_abrir_cena_como_popup(cena_c)
	
func _on_botao_D_pressed():
	_abrir_cena_como_popup(cena_d)
	
func _on_botao_e_pressed():
	_abrir_cena_como_popup(cena_e)	

# Função para avançar o mês e calcular dinheiro
func _on_botao_passar_mes_pressed():
	_avancar_periodo()

func _avancar_periodo() -> void:
	_calcular_avanco_de_periodo(_calcular_ganhos_e_prejuizos)

### --- UTILS ---
# TODO p/ Gabriel - No futuro, avaliar a viabilidae de extrair funcoes
# auxiliares dessa natureza para modulos externos para enxugar o script main

# Função auxiliar para abrir uma tela popup
func _abrir_cena_como_popup(cena: PackedScene) -> void:
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


# Realiza o calculo de avanco de periodo e atualiza o HUD	
func _calcular_avanco_de_periodo(get_lucros_e_prejuizos: Callable) -> void:
	# Realiza o calculo de avanco de periodo e atualiza o HUD
		
	# Chama a funcao para saber quanto foi o resultado do periodo
	var res: int = get_lucros_e_prejuizos.call()
	# Adiciona o resultado do calculo processado na verba do trabalhador
	conta_corrente += res

	# Se mes atual for 12, retornar para 1, senao, incrementar mes
	# isso remove a complexidade do %12 do acesso ao array de meses
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
	# Para reference, voce pode fazer print assim para debuar valores
	print("Mes atual: ", mes_atual)
	print("Ano atual: " + str(ano_atual))
	_atualizar_cabecalho_de_status()

# Atualiza os textos na HUD
func _atualizar_cabecalho_de_status():
	var mes_texto = Utils.NOMES_MESES_3_CHARS[(mes_atual - 1)]
	# TODO Bruno - se for adicionar idade, criar uma label propria para essa ubfirnacai
	mes_ano_label.text = "%s/Ano %02d - Idade %d anos" % [mes_texto, ano_atual, idade]
	conta_corrente_label.text = "R$ %.2f" % conta_corrente

# Inicializa o estado do jogo ao começar a cena.
func _iniciar_jogo() -> void:
	# Conecta sinais dos botões para funções específicas
	botao_loja.pressed.connect(_on_botao_loja_pressed)
	botao_inventario.pressed.connect(_on_botao_inventario_pressed)
	botao_opcoes.pressed.connect(_on_botao_opcoes_pressed)
	botao_passar_mes.pressed.connect(_on_botao_passar_mes_pressed)
	botao_status.pressed.connect(_on_botao_status_pressed)
	botao_d.pressed.connect(_on_botao_D_pressed)
	botao_e.pressed.connect(_on_botao_e_pressed)

	# Atualiza os labels da HUD com os valores iniciais
	_atualizar_cabecalho_de_status()

# Funcao que ira auxiliar na computacao de lucros e prejuizos no futuro - valor fixo temporario
func _calcular_ganhos_e_prejuizos(args = 0) -> int:
	if args > 0: return args
	return 100
