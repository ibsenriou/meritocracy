extends Node


# --- Sinais ---
signal money_changed(new_value)
signal salary_changed(new_value)
signal period_advanced(new_value)

# --- Dados do jogador ---
var money: int = 0 # Valor na conta
var salary: int = 2000 # Salario Mensal
var expenses: int = 1900 # Gastos mensais
var time: int = 1 # Valor inteiro usado para calcular o tempo interno no jogo

# --- Loja (itens sempre disponíveis) ---
# Cada item tem: { "price": int, "bonus": int }
var loja_items: Dictionary = {
	"curso_basico": {"price": 500,   "bonus": 50},
	"curso_inter":  {"price": 5000,  "bonus": 250},
	"curso_avanc":  {"price": 150000,"bonus": 1500}
}

# ---------------- Tempo ------------------
func advance_period(profit: int) -> void:
	add_money(profit)
	time += 1 # Avance time by 1 unit

	emit_signal("period_advanced", time)
	save_game()  # ← automatically save after every period advance

# ---------------- Dinheiro ----------------
func can_afford(amount: int) -> bool:
	return money >= amount

func add_money(amount: int) -> void:
	money += amount
	emit_signal("money_changed", money)
#
func spend_money(amount: int) -> void:
	money -= amount
	emit_signal("money_changed", money)

func get_salary() -> int:
	return salary

func add_salary(amount: int) -> void:
	salary += amount
	emit_signal("salary_changed", salary)

# ---------------- Loja ----------------
func get_price(item_id: String) -> int:
	if loja_items.has(item_id):
		return int(loja_items[item_id]["price"])
	return -1

# comprar item (só checa saldo e aplica bônus)
func buy_item(item_id: String) -> bool:
	if not loja_items.has(item_id):
		return false
	var data = loja_items[item_id]
	var price = int(data["price"])
	var bonus = int(data["bonus"])

	if can_afford(price):
		spend_money(price)
		
		if bonus != 0:
			add_salary(bonus)
		return true
	return false


### Save Game Mechanics
func save_game(file_path: String = "user://meritocracy-save-state-1.save") -> void:
	var save_data := {
		"money": money,
		"salary": salary,
		"time": time,
		"expenses": expenses
		# add other global states here
	}
	
	print("Game saving at path: ", ProjectSettings.globalize_path("user://"))
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("✅ Game saved to ", file_path)
	else:
		push_error("Failed to open save file for writing")
		
### Load Game Mechanics
func load_game(file_path: String = "user://meritocracy-save-state-1.save") -> void:
	if not FileAccess.file_exists(file_path):
		print("No save file found at ", file_path)
		return
	
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		# restore global variables
		money = save_data.get("money", 0)
		salary = save_data.get("salary", 2000)
		time = save_data.get("time", 1)
		expenses = save_data.get("expenses", 0)
		
		# emit signals so HUD/UI updates
		emit_signal("money_changed", money)
		emit_signal("period_advanced", null)
		
		print("✅ Game loaded from ", file_path)
	else:
		push_error("Failed to open save file for reading")

func _ready():
	load_game()  # auto-load the last save
