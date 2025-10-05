class_name ExpenseFactory
extends RefCounted

# Registry of expense types (can be extended without modifying factory)
static var expense_registry: Dictionary = {}

# Register expense types at startup
static func register_defaults():
	expense_registry["rent"] = RentExpense
	expense_registry["food"] = FoodExpense
	expense_registry["energy"] = EnergyExpense
	#expense_registry["taxes"] = TaxExpense
	#expense_registry["entertainment"] = EntertainmentExpense
	#expense_registry["education"] = EducationExpense

# Register new expense types dynamically (Open for extension)
static func register_expense(type_name: String, expense_class):
	expense_registry[type_name] = expense_class

# Create expense with parameters
static func create_expense(type_name: String, params: Dictionary) -> BaseExpense:
	if not expense_registry.has(type_name):
		push_error("Unknown expense type: " + type_name)
		return null
	
	var expense_class = expense_registry[type_name]
	
	# Create instance based on type with appropriate parameters
	match type_name:
		"rent":
			return expense_class.new(
				params.get("amount", 1000.0),
				params.get("location_multiplier", 1.0)
			)
		"food":
			return expense_class.new(
				params.get("amount", 200.0),
				params.get("people", 1)
			)
		"energy":
			return expense_class.new(
				params.get("amount", 150.0),
				params.get("usage", 1.0)
			)
		#"taxes":
			#return expense_class.new(
				#params.get("income", 5000.0),
				#params.get("rate", 0.2)
			#)
		#"entertainment":
			#return expense_class.new(params.get("amount", 100.0))
		#"education":
			#return expense_class.new(params.get("amount", 300.0))
		_:
			# Default constructor for custom expenses
			return expense_class.new(params.get("amount", 0.0))
