extends Control
class_name FooterHUD

signal go_to_main
signal go_to_store
signal open_inventory
signal open_options
signal open_status
signal open_d
signal open_e

@onready var store_button: TextureButton = $HBoxContainer/StoreButton
@onready var inventory_button: TextureButton = $HBoxContainer/InventoryButton
@onready var status_button: TextureButton = $HBoxContainer/StatusButton
@onready var tbdfAbtn: TextureButton = $HBoxContainer/ToBeDefinedAButton
@onready var tbdfBbtn: TextureButton = $HBoxContainer/ToBeDefinedBButton

func _ready():
	store_button.pressed.connect(func(): emit_signal("go_to_store"))
	inventory_button.pressed.connect(func(): emit_signal("go_to_inventory"))
	status_button.pressed.connect(func(): emit_signal("go_to_status"))
	tbdfAbtn.pressed.connect(func(): emit_signal("go_to_a"))
	tbdfBbtn.pressed.connect(func(): emit_signal("go_to_b"))
