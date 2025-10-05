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
	
		# Connect to expenses changes
	Global.connect("expenses_changed", Callable(self, "_on_expenses_changed"))
	
	MusicManager.play_music("gameplay")
	
# NEW: Update display when expenses change
func _on_expenses_changed(_new_value):
	_update_display()

# NEW: Helper to update all UI elements
func _update_display():
	header.update_status(Global.time, Global.money)
	# You could add expense display in header/footer if desired

# --- MECÂNICA DE TEMPO ---
func _on_advance_period_button_pressed() -> void:
	var profit_or_loss = calculate_profit_or_loss()
	_advance_period(profit_or_loss)
	header.update_status(Global.time, Global.money) # keep header in sync


func _advance_period(profit_or_loss: int) -> void:
	"""
	Advance the global period by 1 unit and apply the profit or loss.
	"""
	Global.advance_period(profit_or_loss)


# --- PROFITS / LOSSES ---
func calculate_profit_or_loss() -> int:
	"""
	Compute net gain/loss for the current period.
	Now uses the dynamic expenses system.
	"""
	var current_expenses = Global.get_expenses()  # CHANGED: use new system
	return Global.salary - current_expenses
