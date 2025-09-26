extends Node


# --- Sinais ---
signal dinheiro_changed(new_value)
signal salario_changed(new_value)

# --- Dados do jogador ---
var dinheiro: int = 0
var salario: int = 2000
var mes: int = 1
var ano: int = 1
var idade: int = 18

# --- Loja (itens sempre disponíveis) ---
# Cada item tem: { "price": int, "bonus": int }
var loja_items: Dictionary = {
	"curso_basico": {"price": 500,   "bonus": 50},
	"curso_inter":  {"price": 5000,  "bonus": 250},
	"curso_avanc":  {"price": 150000,"bonus": 1500}
}

# ---------------- Dinheiro ----------------
func can_afford(amount: int) -> bool:
	return dinheiro >= amount

func add_money(amount: int) -> void:
	dinheiro += amount
	emit_signal("dinheiro_changed", dinheiro)

func spend_money(amount: int) -> bool:
	if can_afford(amount):
		dinheiro -= amount
		emit_signal("dinheiro_changed", dinheiro)
		return true
	return false

func get_salary() -> int:
	return salario

func add_salary(amount: int) -> void:
	salario += amount
	emit_signal("salario_changed", salario)

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

	if spend_money(price):
		if bonus != 0:
			add_salary(bonus)
		return true
	return false

# ---------------- Formatação ----------------
static func format_money(value: int) -> String:
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
