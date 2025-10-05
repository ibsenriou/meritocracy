extends Control
class_name FooterHUD

# Scene paths - centralized for easy maintenance
const MAIN_SCENE = "res://Scene/MainScene/main_scene.tscn"
const STORE_SCENE = "res://Scene/LojaScene/loja_scene.tscn"
const INVENTORY_SCENE = "res://Scene/ExpensesScene/ExpensesScene.tscn"  # Update path when created
const STATUS_SCENE = "res://Scene/StatusScene/status_scene.tscn"  # Update path when created
# Add more scenes as needed

@onready var store_button: TextureButton = $HBoxContainer/StoreButton
@onready var inventory_button: TextureButton = $HBoxContainer/InventoryButton
@onready var status_button: TextureButton = $HBoxContainer/StatusButton
@onready var tbdfAbtn: TextureButton = $HBoxContainer/ToBeDefinedAButton
@onready var tbdfBbtn: TextureButton = $HBoxContainer/ToBeDefinedBButton

# Track current scene to implement toggle behavior
var current_scene_path: String = ""

func _ready():
	# Get the current scene path
	current_scene_path = get_tree().current_scene.scene_file_path
	
	# Connect buttons to navigation methods
	store_button.pressed.connect(_on_store_button_pressed)
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	status_button.pressed.connect(_on_status_button_pressed)
	tbdfAbtn.pressed.connect(_on_tbdf_a_button_pressed)
	tbdfBbtn.pressed.connect(_on_tbdf_b_button_pressed)
	
	# Optional: Update button states to show current scene
	_update_button_states()

# --- NAVIGATION METHODS ---

func _on_store_button_pressed():
	# Toggle: if in store, go to main; otherwise go to store
	if current_scene_path == STORE_SCENE:
		_navigate_to(MAIN_SCENE)
	else:
		_navigate_to(STORE_SCENE)

func _on_inventory_button_pressed():
	# Toggle: if in inventory, go to main; otherwise go to inventory
	if current_scene_path == INVENTORY_SCENE:
		_navigate_to(MAIN_SCENE)
	else:
		_navigate_to(INVENTORY_SCENE)

func _on_status_button_pressed():
	# Toggle: if in status, go to main; otherwise go to status
	if current_scene_path == STATUS_SCENE:
		_navigate_to(MAIN_SCENE)
	else:
		_navigate_to(STATUS_SCENE)

func _on_tbdf_a_button_pressed():
	# Placeholder for future scene
	print("Button A pressed - scene not yet defined")
	# _navigate_to(SCENE_A)

func _on_tbdf_b_button_pressed():
	# Placeholder for future scene
	print("Button B pressed - scene not yet defined")
	# _navigate_to(SCENE_B)

# --- HELPER METHODS ---

func _navigate_to(scene_path: String):
	"""Navigate to a specific scene"""
	if scene_path.is_empty():
		push_error("Cannot navigate to empty scene path")
		return
	
	# Optional: Add transition effect here
	get_tree().change_scene_to_file(scene_path)

func _update_button_states():
	"""
	Optional: Visual feedback to show which scene is active
	You could change button modulation, disable it, or add an indicator
	"""
	# Example: Slightly dim the button for the current scene
	store_button.modulate = Color.WHITE if current_scene_path != STORE_SCENE else Color(0.7, 0.7, 0.7)
	inventory_button.modulate = Color.WHITE if current_scene_path != INVENTORY_SCENE else Color(0.7, 0.7, 0.7)
	status_button.modulate = Color.WHITE if current_scene_path != STATUS_SCENE else Color(0.7, 0.7, 0.7)

# --- PUBLIC API (if you need programmatic navigation from other scripts) ---

func navigate_to_main():
	_navigate_to(MAIN_SCENE)

func navigate_to_store():
	_navigate_to(STORE_SCENE)

func navigate_to_inventory():
	_navigate_to(INVENTORY_SCENE)

func navigate_to_status():
	_navigate_to(STATUS_SCENE)
