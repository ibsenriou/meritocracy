extends MarginContainer  # ou qualquer que seja o nó raiz

@onready var botao_fechar: Button = $VBoxContainer/HBoxContainer/BotaoFechar

func _ready():
	botao_fechar.pressed.connect(fechar_tela)

func fechar_tela():
	queue_free()
