extends Control

# --- BOTÕES ---
@onready var advance_period_button: TextureButton = $AdvancePeriodButton

# --- Header + Footer ---
@onready var footer: FooterHUD  = $FooterHud
@onready var header: HeaderHUD = $HeaderHud

# --- UTILS ---
const Utils = preload("res://Scene/Scripts/Utils.gd") ## Utils script importado pois não é um autoload
# Autoload são classes usando o padrão Singleton, são classes que instanciam um único objeto imediatamente quando importada
# Como o utils usará apenas métodos estáticos para organização do código, você nao precisar instanciar uma classe utils()
# apenas chamar Utils.format_money e não preciasa usar var utils = new Utils() e entao utils.format_money().

func _ready():
	# Header + Footer signals
	# Avançar período e atualizar HUD
	advance_period_button.pressed.connect(_on_advance_period_button_pressed)
	
	# Footer botoes on Click connect
	footer.go_to_store.connect(func(): get_tree().change_scene_to_file(
		"res://Scene/LojaScene/loja_scene.tscn"
	))

	MusicManager.play_music("gameplay")


# --- MECÂNICA DE TEMPO ---
func _on_advance_period_button_pressed() -> void:
	var profit_or_loss = _calculate_profit_or_loss()
	_advance_period(profit_or_loss)
	header.update_status(Global.time, Global.money) # keep header in sync


func _advance_period(profit_or_loss: int) -> void:
	"""
	Advance the global period by 1 unit and apply the profit or loss.
	"""
	Global.advance_period(profit_or_loss)


# --- PROFITS / LOSSES ---
func _calculate_profit_or_loss() -> int:
	"""
	Compute net gain/loss for the current period.
	"""
	return Global.salary - Global.expenses
