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
func advance_period(lucro: int) -> void:
	add_money(lucro)

	time += 1

	emit_signal("period_advanced", time)

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

# ---------------- Formatação ----------------
func format_money(value: int) -> String:
	if value >= 1_000_000:
		var result = value / 1_000_000.0
		var s = str(round(result * 10) / 10.0)
		s = s.rstrip("0").rstrip(".")
		return s + "kk"
	elif value >= 1_000:
		var result = value / 1_000.0
		var s = str(round(result * 10) / 10.0)
		s = s.rstrip("0").rstrip(".")
		return s + "k"
	else:
		return str(value)
