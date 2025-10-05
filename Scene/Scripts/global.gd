extends Node

# --- Sinais ---
signal money_changed(new_value)
signal salary_changed(new_value)
signal period_advanced(new_value)
signal expenses_changed(new_value)  # NEW: signal when expenses change

# --- Dados do jogador ---
var money: int = 0 # Valor na conta
var salary: int = 2000 # Salario Mensal
var time: int = 1 # Valor inteiro usado para calcular o tempo interno no jogo

# NEW: Expenses system (replaces the simple int)
var losses_manager: LossesManager = null

# --- Loja (itens sempre disponíveis) ---
# Cada item tem: { "price": int, "bonus": int }
var loja_items: Dictionary = {
	"curso_basico": {"price": 500,   "bonus": 50},
	"curso_inter":  {"price": 5000,  "bonus": 250},
	"curso_avanc":  {"price": 150000,"bonus": 1500}
}

func _ready():
	_initialize_expenses_system()
	load_game()  # auto-load the last save
	
# NEW: Initialize expenses system
func _initialize_expenses_system() -> void:
	losses_manager = LossesManager.new()
	add_child(losses_manager)
	
	# Connect to expenses signals
	losses_manager.monthly_losses_calculated.connect(_on_monthly_losses_calculated)
	losses_manager.expense_added.connect(_on_expense_changed)
	losses_manager.expense_removed.connect(_on_expense_changed)
	
	# Setup default expenses (matching your original 1900)
	# You can adjust these values to total ~1900
	losses_manager.add_expense("rent", {"amount": 800.0})
	losses_manager.add_expense("food", {"amount": 500.0, "people": 1})
	losses_manager.add_expense("energy", {"amount": 200.0, "usage": 1.0})
	losses_manager.add_expense("entertainment", {"amount": 200.0})
	losses_manager.add_expense("taxes", {"income": float(salary), "rate": 0.1})
	# Total: ~1900

# NEW: Signal handlers for expenses
func _on_monthly_losses_calculated(total: float) -> void:
	emit_signal("expenses_changed", int(total))

func _on_expense_changed(_param = null) -> void:
	# Recalculate when expenses are added/removed
	var total = losses_manager.process_monthly_losses()
	emit_signal("expenses_changed", int(total))

# NEW: Get current total expenses
func get_expenses() -> int:
	if losses_manager:
		return int(losses_manager.get_current_monthly_total())
	return 0

# NEW: Add a new expense type
func add_expense(type: String, params: Dictionary) -> void:
	if losses_manager:
		losses_manager.add_expense(type, params)

# NEW: Remove an expense
func remove_expense(expense_name: String) -> bool:
	if losses_manager:
		return losses_manager.remove_expense(expense_name)
	return false

# NEW: Update expense parameters (e.g., when family grows)
func update_expense(expense_name: String, new_params: Dictionary) -> bool:
	if losses_manager:
		return losses_manager.update_expense(expense_name, new_params)
	return false

# NEW: Get breakdown for UI display
func get_expense_breakdown() -> Array:
	if losses_manager:
		return losses_manager.get_expense_breakdown()
	return []

func advance_period(profit: int) -> void:
	# --- Debug: BEFORE advancing ---
	print("==============================")
	print(">> ADVANCE PERIOD - BEFORE")
	print("Time:", self.time)
	print("Money:", self.money)
	print("Salary:", self.salary)
	print("Expenses:", get_expenses())  # CHANGED: use new system
	print("Profit to apply:", profit)
	print("==============================")
	
	# Calculate monthly losses
	var monthly_expenses = losses_manager.process_monthly_losses()
	
	# Advance the period
	print("Avançando para o próximo período")
	time += 1
	add_money(profit)
	
	# --- Debug: AFTER advancing ---
	print("==============================")
	print(">> ADVANCE PERIOD - AFTER")
	print("Time:", self.time)
	print("Money:", self.money)
	print("Salary:", self.salary)
	print("Expenses:", int(monthly_expenses))
	print("==============================")
	
	# Expense breakdown (for debugging)
	print("\n--- Expense Breakdown ---")
	for expense in get_expense_breakdown():
		print("  %s: $%.2f" % [expense.name, expense.amount])
	print("-------------------------\n")
	
	emit_signal("period_advanced", time)
	save_game()

# ---------------- Dinheiro ----------------
func can_afford(amount: int) -> bool:
	return money >= amount

func add_money(amount: int) -> void:
	money += amount
	emit_signal("money_changed", money)

func spend_money(amount: int) -> void:
	money -= amount
	emit_signal("money_changed", money)

func get_salary() -> int:
	return salary

func add_salary(amount: int) -> void:
	salary += amount
	# Update taxes when salary changes
	if losses_manager:
		losses_manager.update_expense("Taxes", {"income": float(salary)})
	emit_signal("salary_changed", salary)

# ---------------- Loja ----------------
func get_price(item_id: String) -> int:
	if loja_items.has(item_id):
		return int(loja_items[item_id]["price"])
	return -1

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
	# Prepare expenses data for saving
	var expenses_data = []
	if losses_manager:
		for expense in losses_manager.expenses:
			var expense_dict = {
				"type": _get_expense_type(expense),
				"name": expense.expense_name,
				"base_amount": expense.base_amount
			}
			
			# Save type-specific data
			if expense is RentExpense:
				expense_dict["location_multiplier"] = expense.location_multiplier
			elif expense is FoodExpense:
				expense_dict["people"] = expense.people_count
			elif expense is EnergyExpense:
				expense_dict["usage"] = expense.usage_factor
			#elif expense is TaxExpense:
				#expense_dict["rate"] = expense.tax_rate
			
			expenses_data.append(expense_dict)
	
	var save_data := {
		"money": money,
		"salary": salary,
		"time": time,
		"expenses_data": expenses_data  # NEW: save detailed expenses
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
		
		# Restore global variables
		money = save_data.get("money", 0)
		salary = save_data.get("salary", 2000)
		time = save_data.get("time", 1)
		
		# NEW: Restore expenses
		var expenses_data = save_data.get("expenses_data", [])
		if expenses_data.size() > 0 and losses_manager:
			_restore_expenses(expenses_data)
		
		# Emit signals so HUD/UI updates
		emit_signal("money_changed", money)
		emit_signal("period_advanced", time)
		emit_signal("expenses_changed", get_expenses())
		
		print("✅ Game loaded from ", file_path)
	else:
		push_error("Failed to open save file for reading")

# NEW: Helper to restore expenses from save data
func _restore_expenses(expenses_data: Array) -> void:
	losses_manager.clear_expenses()
	
	for expense_dict in expenses_data:
		var type = expense_dict.get("type", "")
		var params = {}
		
		# Reconstruct parameters based on type
		params["amount"] = expense_dict.get("base_amount", 0.0)
		
		if expense_dict.has("location_multiplier"):
			params["location_multiplier"] = expense_dict["location_multiplier"]
		if expense_dict.has("people"):
			params["people"] = expense_dict["people"]
		if expense_dict.has("usage"):
			params["usage"] = expense_dict["usage"]
		if expense_dict.has("rate"):
			params["rate"] = expense_dict["rate"]
			params["income"] = float(salary)
		
		losses_manager.add_expense(type, params)

# NEW: Helper to determine expense type
func _get_expense_type(expense: BaseExpense) -> String:
	if expense is RentExpense:
		return "rent"
	elif expense is FoodExpense:
		return "food"
	elif expense is EnergyExpense:
		return "energy"
	#elif expense is TaxExpense:
		#return "taxes"
	#elif expense is EntertainmentExpense:
		#return "entertainment"
	#elif expense is EducationExpense:
		#return "education"
	return "unknown"
