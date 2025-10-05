class_name EnergyExpense
extends BaseExpense

var usage_factor: float

func _init(amount: float, usage: float = 1.0):
	super("Energy", amount)
	usage_factor = usage

func calculate_monthly_cost() -> float:
	return base_amount * usage_factor
