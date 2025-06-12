extends PopupPanel

var salario: float
var gastos: float
var resultado: float
var poupanca: float
var mes_inicial: String

func _ready():
	# Preenche as Labels com os dados recebidos
	$VBoxContainer/MesLabel.text = "Mês: " + mes_inicial
	$VBoxContainer/SalarioLabel.text = "Salário: R$ " + str("%.2f" % salario)
	$VBoxContainer/GastosLabel.text = "Gastos: R$ " + str("%.2f" % gastos)
	$VBoxContainer/ResultadoLabel.text = "Resultado: R$ " + str("%.2f" % resultado)
	$VBoxContainer/PoupancaLabel.text = "Poupança: R$ " + str("%.2f" % poupanca)

func setup(
	salario: float,
	gasto: float,
	resultado: float,
	poupanca: float,
	mes_inicial: String
):
	salario = salario
	gastos = gastos
	resultado = resultado
	poupanca = poupanca
	mes_inicial = mes_inicial


func _on_BotaoFechar_pressed():
	queue_free()


func _on_fechar_btn_pressed() -> void:
	queue_free()
