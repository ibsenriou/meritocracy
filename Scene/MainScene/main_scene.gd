extends Control

# --- CENAS DOS POPUPS ---
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
	Global.advance_period(res)   # atualiza dinheiro + tempo

# --- HUD ---
func _atualizar_cabecalho_de_status():
	mes_ano_label.text = "Tempo Atual: " + str(Global.time)
	conta_corrente_label.text = "R$ " + Global.format_money(int(Global.money))

func _on_money_changed(new_value):
	conta_corrente_label.text = "R$ " + Global.format_money(int(new_value))

func _on_period_advanced(_new_value):
	_atualizar_cabecalho_de_status()


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
	
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	Global.connect("period_advanced", Callable(self, "_on_period_advanced"))

	_atualizar_cabecalho_de_status()

	_atualizar_cabecalho_de_status()

# --- LUCROS/PREJUÍZOS ---
func _calcular_ganhos_e_prejuizos() -> int:
	## Após atualizados os valores de Gasto e Salário, o cálculo de Lucros
	## e prejuízo é uma simples subtração
	return Global.salary - Global.expenses
