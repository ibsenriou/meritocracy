extends Control
class_name BaseTela

# NÓS - ajuste os caminhos se os nomes forem diferentes
@onready var mes_ano_label: Label = $TopoHUD/MesAnoLabel
@onready var conta_corrente_label: Label = $TopoHUD/ContaCorrenteLabel

@onready var tela_ativa: Control = $TelaAtiva

@onready var botao_passar_mes: Button = $Rodape/BotaoPassarMes
@onready var botao_loja: Button = $Rodape/BotoesInferiores/BotaoLoja
@onready var botao_inventario: Button = $Rodape/BotoesInferiores/BotaoInventario
@onready var botao_status: Button = $Rodape/BotoesInferiores/BotaoStatus
@onready var botao_d: Button = $Rodape/BotoesInferiores/BotaoD
@onready var botao_e: Button = $Rodape/BotoesInferiores/BotaoE
@onready var botao_ver_lore: Button = $Rodape/BotoesInferiores/VerLoreButton

# Estado (você provavelmente já tem no MainScene, mova pro lugar central depois)
var mes_atual: int = 1
var ano_atual: int = 79
var idade: int = 79
var conta_corrente: float = 0.0

func _ready() -> void:
	_conectar_botoes_base()
	atualizar_hud()

# conecta os botões do rodapé ao comportamento base
func _conectar_botoes_base() -> void:
	if botao_passar_mes:
		botao_passar_mes.pressed.connect(_on_botao_passar_mes)
	if botao_loja:
		botao_loja.pressed.connect(_on_botao_loja)
	if botao_inventario:
		botao_inventario.pressed.connect(_on_botao_inventario)
	if botao_status:
		botao_status.pressed.connect(_on_botao_status)
	if botao_d:
		botao_d.pressed.connect(_on_botao_D)
	if botao_e:
		botao_e.pressed.connect(_on_botao_e)
	if botao_ver_lore:
		botao_ver_lore.pressed.connect(_on_ver_lore_button_pressed)

# ----- Funções que podem ser sobrescritas pelas telas filhas -----
func _on_botao_passar_mes():
	# comportamento padrão: podes sobrescrever na TelaMain se quiser
	_avancar_periodo()

func _on_botao_loja():
	# comportamento padrão: trocar de cena herdada
	get_tree().change_scene_to_file("res://Scene/popups/TelaLoja.tscn") # ajuste caminho se quiser

func _on_botao_inventario():
	get_tree().change_scene_to_file("res://Scene/popups/tela_inventario.tscn")

func _on_botao_status():
	# exemplo
	print("Status (base)")

func _on_botao_D():
	print("D (base)")

func _on_botao_e():
	print("E (base)")

func _on_ver_lore_button_pressed():
	# este método pode instanciar seu LoreModal como antes
	var lore_modal_scene := preload("res://Scene/Modals/LoreModal.tscn")
	var modal = lore_modal_scene.instantiate()
	get_tree().current_scene.add_child(modal)
	if modal.has_method("get_lore_data"):
		var lore = modal.get_lore_data("intro") # exemplo
		if lore:
			modal.setup(lore["phrases"])
			_set_input_blocked(true)
	else:
		push_error("LoreModal sem get_lore_data()")

# ----- POPUP UTILS (reaproveita seu _abrir_cena_como_popup) -----
var tela_atual: Node = null
func _abrir_cena_como_popup(cena: PackedScene) -> void:
	if tela_atual and tela_atual.is_inside_tree():
		if tela_atual.scene_file_path == cena.resource_path:
			tela_atual.queue_free()
			tela_atual = null
			if botao_passar_mes: botao_passar_mes.show()
			return
		else:
			tela_atual.queue_free()
			tela_atual = null

	if botao_passar_mes: botao_passar_mes.hide()
	tela_atual = cena.instantiate()
	tela_ativa.add_child(tela_atual)

	await get_tree().process_frame
	var area = tela_ativa.get_size()
	tela_atual.position = area / 2 - tela_atual.size / 2

# ----- HUD / formatação -----
func atualizar_hud():
	var mes_texto = Utils.NOMES_MESES_3_CHARS[(mes_atual - 1)]
	mes_ano_label.text = "%s/Ano %02d - Idade %d anos" % [mes_texto, ano_atual, idade]
	conta_corrente_label.text = "R$ " + format_money(int(conta_corrente))

func set_conta_corrente(novo_valor: float) -> void:
	conta_corrente = novo_valor
	atualizar_hud()

func _set_input_blocked(block: bool) -> void:
	# desabilita botões básicos
	if botao_passar_mes: botao_passar_mes.disabled = block
	if botao_loja: botao_loja.disabled = block
	if botao_inventario: botao_inventario.disabled = block
	if botao_status: botao_status.disabled = block
	if botao_d: botao_d.disabled = block
	if botao_e: botao_e.disabled = block
	if botao_ver_lore: botao_ver_lore.disabled = block

# ----- tempo e conta (pode ser sobrescrito) -----
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
		idade = 18
		ano_atual = 1
		mes_atual = 1
	atualizar_hud()

# ----- util de formatação (mesma que já tem) -----
static func format_money(value: int) -> String:
	if value >= 1_000_000:
		var result = value / 1_000_000.0
		return str(round(result * 10) / 10) + "kk"
	elif value >= 1_000:
		var result = value / 1_000.0
		return str(round(result * 10) / 10) + "k"
	else:
		return str(value)
