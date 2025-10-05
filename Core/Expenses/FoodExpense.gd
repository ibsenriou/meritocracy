class_name FoodExpense
extends BaseExpense

var people_count: int

func _init(amount: float, people: int = 1):
	super("Food", amount)
	people_count = people

func calculate_monthly_cost() -> float:
	return base_amount * people_count
