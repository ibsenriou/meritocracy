extends Control

@onready var botao_comprar_valor: Button = $CanvasLayer/ScrollContainer/MarginContainer/VBoxContainer/ItemCursoBasico/BotaoComprarValor

@onready var header: HeaderHUD = $HeaderHud
@onready var footer: FooterHUD = $FooterHud

const Utils = preload("res://Scene/Scripts/Utils.gd") ## Utils script importado pois não é um autoload
# Autoload são classes usando o padrão Singleton, são classes que instanciam um único objeto imediatamente quando importada
# Como o utils usará apenas métodos estáticos para organização do código, você nao precisar instanciar uma classe utils()
# apenas chamar Utils.format_money e não preciasa usar var utils = new Utils() e entao utils.format_money().


func _ready():
	MusicManager.play_music("store")
	
	# Initial HUD update
	header.update_status(Global.time, Global.money)
	
	# Footer signals
	footer.go_to_store.connect(_on_go_to_main)
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	
	# Connect buy button
	botao_comprar_valor.pressed.connect(_on_botao_comprar_valor_pressed)


func _on_go_to_main():
	get_tree().change_scene_to_file("res://Scene/MainScene/main_scene.tscn")

func _on_money_changed(new_value):
	header.update_status(Global.time, new_value)
	
func _on_botao_comprar_valor_pressed():
	print("Pressed Buy Button")
	var item_id = "curso_basico"
	if Global.buy_item(item_id):
		print("✅ Compra bem-sucedida! Dinheiro: ", Global.money, " & Salário: ", Global.salary)
		
	else:
		print("❌ Sem dinheiro suficiente para comprar o curso básico.")
