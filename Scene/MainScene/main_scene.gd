extends Control

# --- CENAS DOS POPUPS ---
@onready var cena_loja: PackedScene = preload("res://Scene/popups/TelaLoja.tscn")
@onready var cena_inventario: PackedScene = preload("res://Scene/popups/tela_inventario.tscn")
@onready var cena_opcoes: PackedScene = preload("res://Scene/popups/TelaOpcoes.tscn")
@onready var cena_c: PackedScene = preload("res://Scene/popups/tela_c.tscn")
@onready var cena_d: PackedScene = preload("res://Scene/popups/tela_d.tscn")
@onready var cena_e: PackedScene = preload("res://Scene/popups/tela_e.tscn")
var LoreModalScene = preload("res://Scene/Modals/LoreModal.tscn")

# --- UI ---
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel
@onready var conta_corrente_label: Label = $TopoHUD/ContaCorrenteLabel

# --- BOTÕES ---
@onready var botao_inventario: TextureButton = $BotoesInferiores/HBoxContainer/BotaoInventario
@onready var botao_loja: TextureButton = $BotoesInferiores/HBoxContainer/BotaoLoja
@onready var botao_opcoes: TextureButton = $TopoHUD/BotaoOpcoes
@onready var botao_passar_mes: TextureButton = $BotaoPassarMes
@onready var botao_d: TextureButton = $BotoesInferiores/HBoxContainer/BotaoD
@onready var botao_e: TextureButton = $BotoesInferiores/HBoxContainer/BotaoE
@onready var botao_status: TextureButton = $BotoesInferiores/HBoxContainer/BotaoStatus
@onready var botao_ver_lore: Button = $VerLoreButton

# --- POPUPS / TELAS ---
@onready var tela_ativa: Control = $TelaAtiva
var tela_atual: Node = null

# --- ESTADO DO JOGO ---
var mes_atual: int = 1
var ano_atual: int = 79
var idade: int = 79
var conta_corrente: float = 0.0

func _ready():
	_iniciar_jogo()

# --- BOTÕES ---
func _on_botao_loja_pressed():
	get_tree().change_scene_to_file("res://Scene/LojaScene/loja_scene.tscn")

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

func _on_botao_passar_mes_pressed():
	_avancar_periodo()

func _on_ver_lore_button_pressed():
	show_lore("intro")

# --- LORE ---
func show_lore(lore_id: String):
	var modal = LoreModalScene.instantiate()
	get_tree().current_scene.add_child(modal)
	if modal.has_method("get_lore_data"):
		var lore = modal.get_lore_data(lore_id)
		if lore:
			# substitui 'setup' por 'open_modal', passando a música principal do jogo
			modal.open_modal($MusicaFundo, lore["phrases"])
			#bloqueia inputs da mainScene enqto ta aberto o modal da lore
			_set_input_blocked(true)
			
	else:
		push_error("LoreModal.gd precisa ter a função `get_lore_data(lore_id: String)` implementada!")

# --- BLOQUEIO DE INPUT QUANDO O MODAL ESTÁ ABERTO ---
func _set_input_blocked(block: bool):
	botao_passar_mes.disabled = block
	botao_loja.disabled = block
	botao_inventario.disabled = block
	botao_opcoes.disabled = block
	botao_status.disabled = block
	botao_d.disabled = block
	botao_e.disabled = block
	botao_ver_lore.disabled = block


# --- POPUPS ---
func _abrir_cena_como_popup(cena: PackedScene) -> void:
	if tela_atual and tela_atual.is_inside_tree():
		if tela_atual.scene_file_path == cena.resource_path:
			tela_atual.queue_free()
			tela_atual = null
			botao_passar_mes.show()
			return
		else:
			tela_atual.queue_free()
			tela_atual = null

	botao_passar_mes.hide()
	tela_atual = cena.instantiate()
	tela_ativa.add_child(tela_atual)

	await get_tree().process_frame
	var area = tela_ativa.get_size()
	tela_atual.position = area / 2 - tela_atual.size / 2

# --- MECÂNICA DE TEMPO ---
func _avancar_periodo() -> void:
	_calcular_avanco_de_periodo(_calcular_ganhos_e_prejuizos)

func _calcular_avanco_de_periodo(get_lucros_e_prejuizos: Callable) -> void:
	var res: int = get_lucros_e_prejuizos.call()
	conta_corrente += res

	mes_atual += 1
	if mes_atual > 12:
		mes_atual = 1
		ano_atual += 1
		idade += 1

	if idade >= 80:
		print("🔁 Nova geração iniciada!")
		idade = 18
		ano_atual = 1
		mes_atual = 1

	print("Mes atual: ", mes_atual)
	print("Ano atual: " + str(ano_atual))
	_atualizar_cabecalho_de_status()

# --- HUD ---
func _atualizar_cabecalho_de_status():
	var mes_texto = Utils.NOMES_MESES_3_CHARS[(mes_atual - 1)]
	mes_ano_label.text = "%s/Ano %02d - Idade %d anos" % [mes_texto, ano_atual, idade]
	# usa a função de abreviação para exibir o saldo formatado
	conta_corrente_label.text = "R$ " + format_money(int(conta_corrente))

# --- INICIALIZAÇÃO ---
func _iniciar_jogo() -> void:
	botao_loja.pressed.connect(_on_botao_loja_pressed)
	botao_inventario.pressed.connect(_on_botao_inventario_pressed)
	botao_opcoes.pressed.connect(_on_botao_opcoes_pressed)
	botao_passar_mes.pressed.connect(_on_botao_passar_mes_pressed)
	botao_status.pressed.connect(_on_botao_status_pressed)
	botao_d.pressed.connect(_on_botao_D_pressed)
	botao_e.pressed.connect(_on_botao_e_pressed)
	botao_ver_lore.pressed.connect(_on_ver_lore_button_pressed)

	_atualizar_cabecalho_de_status()

# --- LUCROS/PREJUÍZOS ---
func _calcular_ganhos_e_prejuizos(args = 0) -> int:
	if args > 0:
		return args
	return 100



### --- UTILS ---
# TODO p/ Gabriel - No futuro, avaliar a viabilidade de extrair funcoes
# auxiliares dessa natureza para modulos externos para enxugar o script main

# Converte valores numéricos para formato abreviado (1k, 1.5k, 1kk, etc.)
static func format_money(value: int) -> String:
	if value >= 1_000_000:  # milhão
		var result = value / 1_000_000.0
		return str(round(result * 10) / 10) + "kk"  # 1kk, 1.5kk etc.
	elif value >= 1_000:  # milhar
		var result = value / 1_000.0
		return str(round(result * 10) / 10) + "k"   # 1k, 2.5k etc.
	else:
		return str(value)  # valores pequenos ficam normais
