class_name BaseExpense
extends RefCounted

var expense_name: String
var base_amount: float

func _init(name: String, amount: float):
	expense_name = name
	base_amount = amount

# Override this in subclasses for custom calculation logic
func calculate_monthly_cost() -> float:
	return base_amount

func get_description() -> String:
	return "%s: $%.2f" % [expense_name, base_amount]
