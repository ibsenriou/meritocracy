extends Control
class_name HeaderHUD

signal period_advanced(new_time)  # ← add this
signal options_clicked
signal request_advance_period  # HUD asks parent to advance the period

# --- UI Labels ---
@onready var time_period_label: Label = $TimePeriodLabel
@onready var account_balance_label: Label = $AccountBalanceLabel

# --- Buttons ---
#@onready var options_button: TextureButton = $OptionsButon


# --- Utils ---
const Utils = preload("res://Scene/Scripts/Utils.gd")


func _ready() -> void:
	# Connect buttons
	#options_button.pressed.connect(func(): print("Navegando para opções"))

	# Connect global signals
	Global.connect("money_changed", Callable(self, "_on_money_changed"))
	Global.connect("period_advanced", Callable(self, "_on_period_advanced"))

	# Initial HUD update
	update_status(Global.time, Global.money)
	

# --- Public API ---
func update_status(time_value: int, money_value: int) -> void:
	var time_info = Utils.get_time_info(time_value)
	var month_name = Utils.get_month_name(time_info.month)  # compute separately

	time_period_label.text = "%s %d — %d anos" % [month_name.substr(0,3), time_info.year, time_info.age]
	account_balance_label.text = "$" + Utils.format_money(int(money_value))

	
# --- Global signal handlers ---
func _on_money_changed(new_value: int) -> void:
	account_balance_label.text = "$ " + Utils.format_money(int(new_value))

func _on_period_advanced(_new_value) -> void:
	update_status(Global.time, Global.money)
