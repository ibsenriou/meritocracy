extends PanelContainer
## A UI panel to display expense breakdown
## Attach this to a Control node in your scene

@onready var expenses_list: VBoxContainer = $MarginContainer/VBoxContainer/ExpensesList
@onready var total_label: Label = $MarginContainer/VBoxContainer/TotalLabel

const Utils = preload("res://Scene/Scripts/Utils.gd")

func _ready():
	# Connect to expenses changes
	Global.connect("expenses_changed", Callable(self, "_on_expenses_changed"))
	

	
	# Initial display
	_update_expenses_display()

func _on_expenses_changed(_new_value):
	_update_expenses_display()

func _update_expenses_display():
	# Clear existing labels
	for child in expenses_list.get_children():
		child.queue_free()
	
	# Get expense breakdown
	var breakdown = Global.get_expense_breakdown()
	
	# Create a label for each expense
	for expense in breakdown:
		var label = Label.new()
		label.text = "%s: %s" % [
			expense.name,
			Utils.format_money(int(expense.amount))
		]
		expenses_list.add_child(label)
	
	# Update total
	var total = Global.get_expenses()
	total_label.text = "Despesa Mensal Total: %s" % Utils.format_money(total)


## Example: Add this to your store scene to show how buying items affects expenses
## For instance, buying "Education" could add an education expense
func example_add_education_expense():
	# When player buys an education item in the store
	Global.add_expense("education", {"amount": 300.0})
	print("Added education expense!")

## Example: Family grows, food expenses increase
func example_family_grows():
	Global.update_expense("Food", {"people": 2})
	print("Food expenses increased for 2 people!")

## Example: Move to expensive neighborhood
func example_move_to_expensive_area():
	Global.update_expense("Rent", {"location_multiplier": 1.5})
	print("Rent increased by 50%!")

## Example: Remove an expense (e.g., paid off debt)
func example_remove_entertainment():
	Global.remove_expense("Entertainment")
	print("Entertainment expense removed!")
