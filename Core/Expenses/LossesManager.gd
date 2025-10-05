class_name LossesManager
extends Node

var expenses: Array[BaseExpense] = []
var current_month_losses: float = 0.0

signal monthly_losses_calculated(total: float)
signal expense_added(expense: BaseExpense)
signal expense_removed(expense_name: String)

func _ready():
	ExpenseFactory.register_defaults()

# Add expense using factory
func add_expense(type: String, params: Dictionary) -> void:
	var expense = ExpenseFactory.create_expense(type, params)
	if expense:
		expenses.append(expense)
		expense_added.emit(expense)

# Calculate monthly losses - call this when advancing time
func process_monthly_losses() -> float:
	current_month_losses = 0.0
	for expense in expenses:
		current_month_losses += expense.calculate_monthly_cost()
	monthly_losses_calculated.emit(current_month_losses)
	return current_month_losses

# Get current total without recalculating
func get_current_monthly_total() -> float:
	return current_month_losses

# Get breakdown of all expenses
func get_expense_breakdown() -> Array:
	var breakdown = []
	for expense in expenses:
		breakdown.append({
			"name": expense.expense_name,
			"amount": expense.calculate_monthly_cost()
		})
	return breakdown

# Remove expense by name
func remove_expense(expense_name: String) -> bool:
	for i in range(expenses.size()):
		if expenses[i].expense_name == expense_name:
			expenses.remove_at(i)
			expense_removed.emit(expense_name)
			return true
	return false

# Update specific expense parameters
func update_expense(expense_name: String, new_params: Dictionary) -> bool:
	for expense in expenses:
		if expense.expense_name == expense_name:
			# Update relevant properties based on expense type
			if expense is RentExpense and new_params.has("location_multiplier"):
				expense.location_multiplier = new_params["location_multiplier"]
			elif expense is FoodExpense and new_params.has("people"):
				expense.people_count = new_params["people"]
			elif expense is EnergyExpense and new_params.has("usage"):
				expense.usage_factor = new_params["usage"]
			
			if new_params.has("amount"):
				expense.base_amount = new_params["amount"]
			return true
	return false

# Clear all expenses
func clear_expenses() -> void:
	expenses.clear()
	current_month_losses = 0.0
