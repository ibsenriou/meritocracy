extends Control

# --- POPUPS ---
@onready var LOJA = preload("res://Scene/popups/loja.tscn")
@onready var INVENTÁRIO = preload("res://Scene/popups/inventário.tscn")
@onready var CONFIGURAÇÕES = preload("res://Scene/popups/configurações.tscn")
@onready var RESUMO_MES = preload("res://Scene/Resumo mes/resumo_mes.tscn")

# --- UI ELEMENTOS ---
@onready var popup_manager = $PopupManager
@onready var mes_label = $HBoxContainer/MesLabel
@onready var dinheiro_label = $HBoxContainer/DinheiroLabel


# --- VARIÁVEIS DO JOGO ---
var idade: int = 0
var dinheiro: float = 0.0
var poupanca: float = 0.0
var salario_mensal: float = 2000.0
var gastos_fixos: float = 1950.0
var mes_atual: int = 1
var ano_atual: int = 79  # começa em 79 para teste
var nomes_meses = ["JAN", "FEV", "MAR", "ABR", "MAI", "JUN", "JUL", "AGO", "SET", "OUT", "NOV", "DEZ"]


func _ready():
	iniciar_jogo()

func iniciar_jogo():
	atualizar_label_mes()
	atualizar_dinheiro()




func atualizar_dinheiro():
	dinheiro_label.text = "R$ " + str("%.2f" % dinheiro)

func atualizar_label_mes():
	var mes_inicial = nomes_meses[(mes_atual - 1) % 12]
	mes_label.text = "%s ANO %02d" % [mes_inicial, ano_atual]

func reiniciar_com_nova_geracao():
	
	mes_atual = 1
	ano_atual = 18
	idade = 18
	

	iniciar_jogo()



func _on_button_a_pressed():
	var popup = LOJA.instantiate()
	popup_manager.add_child(popup)

func _on_button_b_pressed():
	var popup = INVENTÁRIO.instantiate()
	popup_manager.add_child(popup)

func _on_botao_dinheiro_pressed():
	var saldo_mes = salario_mensal - gastos_fixos
	var mes_inicial_formatado = "%s ANO %02d" % [nomes_meses[(mes_atual - 1) % 12], ano_atual]

	dinheiro += saldo_mes
	if saldo_mes > 0:
		poupanca += saldo_mes

	
	atualizar_dinheiro()

	mes_atual += 1
	if mes_atual > 12 && ano_atual == 80:
		reiniciar_com_nova_geracao()
		
	elif mes_atual > 12:
		mes_atual = 1
		ano_atual += 1
		idade += 1

	atualizar_label_mes()

	if idade >= 80:
		reiniciar_com_nova_geracao()
		return

	var geracao_inicial_popup = RESUMO_MES.instantiate()
	geracao_inicial_popup.setup(salario_mensal, gastos_fixos, saldo_mes, poupanca, mes_inicial_formatado)
	popup_manager.add_child(geracao_inicial_popup)
