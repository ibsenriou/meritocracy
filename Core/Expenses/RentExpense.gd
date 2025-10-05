# Concrete expense implementations
class_name RentExpense
extends BaseExpense

var location_multiplier: float

func _init(amount: float, location_mult: float = 1.0):
	super("Rent", amount)
	location_multiplier = location_mult

func calculate_monthly_cost() -> float:
	return base_amount * location_multiplier
