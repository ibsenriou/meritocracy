extends Control

@onready var botao_loja: TextureButton = $HBoxContainer/BotaoLoja



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	botao_loja.pressed.connect(esse_nome_n_impoorta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func esse_nome_n_impoorta():
	print("Botao loja clicu")
	get_tree().change_scene_to_file("res://Scene/MainScene/main_scene.tscn")
	
func _on_button_pressed():
	print("Botao loja clicu")
