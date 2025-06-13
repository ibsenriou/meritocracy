extends Control

# --- POPUPS ---
# TODO: Remover todas as variaveis e nomes de arquivos contendo acentuacao grafica / nunca usar tio acento agudo circunflexo craze ou variados. usar apenas caracteres ASCII em nomes de variaveis e arquivos A-z (incluindo 0-9)
@onready var LOJA = preload("res://Scene/popups/loja.tscn")
@onready var INVENTÁRIO = preload("res://Scene/popups/inventário.tscn")
@onready var CONFIGURAÇÕES = preload("res://Scene/popups/configurações.tscn")
@onready var RESUMO_MES = preload("res://Scene/Resumo mes/resumo_mes.tscn")

# --- UI ELEMENTOS ---
@onready var popup_manager = $PopupManager
@onready var mes_label = $HBoxContainer/MesLabel
@onready var dinheiro_label = $HBoxContainer/DinheiroLabel


# --- VARIÁVEIS DO JOGO ---

# --- Status do Personagem ---
var idade: int = 0
var conta_corrente: float = 0.0

# --- Status do Gerenciador de Renda
var salario_mensal: float = 2000.0
var gastos_fixos: float = 1950.0

# --- Status do Gerenciador de Tempo
var mes_atual: int = 1
var ano_atual: int = 79  # começa em 79 para teste

# --- Variavel Auxiliar para Gerenciamento de Tempo
var nomes_meses = ["JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ"]


func _ready():
	iniciar_jogo()

func atualizar_label_da_ui_de_mes():
	var mes_inicial = nomes_meses[(mes_atual - 1) % 12]
	mes_label.text = "%s ANO %02d" % [mes_inicial, ano_atual]

func atualizar_ui_de_dinheiro():
	dinheiro_label.text = "R$ " + str("%.2f" % conta_corrente)

func atualizar_ui_do_cabecalho_de_status():
	atualizar_label_da_ui_de_mes()
	atualizar_ui_de_dinheiro()

func iniciar_jogo():
	atualizar_ui_do_cabecalho_de_status()


func reiniciar_com_nova_geracao():
	mes_atual = 1
	ano_atual = 18
	idade = 18
	
	iniciar_jogo()

func computar_lucros_e_prejuizos_do_periodo():
	# Nessa funcao ficara toda a logica de calcular e atualizar a UI de dinheiro
	var saldo_mes = salario_mensal - gastos_fixos
	var mes_inicial_formatado = "%s ANO %02d" % [nomes_meses[(mes_atual - 1) % 12], ano_atual]

	conta_corrente += saldo_mes
	
	atualizar_ui_de_dinheiro()

func computar_o_avanco_do_tempo_para_o_proximo_mes():
	# Nessa funcao ficara toda a logica de avancar o periodo de tempo
	mes_atual += 1
	if mes_atual > 12 && ano_atual == 80:
		reiniciar_com_nova_geracao()
		
	elif mes_atual > 12:
		mes_atual = 1
		ano_atual += 1
		idade += 1

	atualizar_label_da_ui_de_mes()

	# Se for fazer resumo mais pra frente vemos onde colocar essas funcoes aqui abaixo pra mostrar o resumoUI Por enquanto nao precisa!
	# var geracao_inicial_popup = RESUMO_MES.instantiate()
	# geracao_inicial_popup.setup(salario_mensal, gastos_fixos, saldo_mes, mes_inicial_formatado)
	# popup_manager.add_child(geracao_inicial_popup)


func avancar_para_o_proximo_mes():
	computar_lucros_e_prejuizos_do_periodo()
	computar_o_avanco_do_tempo_para_o_proximo_mes()

# Perfeito!! So lembrar que quando formos trocar de fato os botoes pra comecar a incorportar logica neles, precisamos trocar o nome de button a para dar um nome expressivo para o botao
# exemplo: on_button_loja_pressed, ai nao esquecer de ajeitar isso depois!
func _on_button_a_pressed():
	var popup = LOJA.instantiate()
	popup_manager.add_child(popup)

func _on_button_b_pressed():
	var popup = INVENTÁRIO.instantiate()
	popup_manager.add_child(popup)

# Igual esta aqui, mas nao vamos chamar esse botao de dinheiro. Apensar de ser um icone de dinheiro ele precisar se chamar algo mais declarativo do que ele faz:
# exemplo: _on_botao_de_avancar_para_o_proximo_mes_pressed
func _on_botao_dinheiro_pressed():
	avancar_para_o_proximo_mes()
