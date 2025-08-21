extends Control

@onready var panel = $ModalContainer
@onready var click_shield: ColorRect = $ModalContainer/ClickShield
@onready var background_blur: ColorRect = $BackgroundBlur
@onready var content_container = $ModalContainer/ContentContainer
@onready var rodape = $ModalContainer/Rodape
@onready var audio_player = $AudioStreamPlayer

var phrases: Array = []
var current_index: int = 0

func _ready() -> void:
	visible = false
	
	# Bloqueia todos os cliques atrás do modal
	mouse_filter = Control.MOUSE_FILTER_STOP
	click_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	background_blur.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Permite clicar no shield para avançar a frase
	click_shield.gui_input.connect(_on_click_shield_input)

# --- EXIGIDO pelo MainScene ---
func get_lore_data(lore_id: String) -> Dictionary:
	# Aqui você pode configurar os textos de acordo com o ID
	# Exemplo simples (substitua pelos seus diálogos reais):
	var lores = {
		"intro": {
			"phrases": [
				"Bem-vindo ao jogo!",
				"Essa é a introdução da história.",
				"Aperte para continuar."
			]
		},
		"capitulo1": {
			"phrases": [
				"O capítulo 1 começa aqui.",
				"Você encontrará novos desafios.",
				"Boa sorte!"
			]
		}
	}
	
	# Retorna o lore correspondente, ou null se não existir
	if lores.has(lore_id):
		return lores[lore_id]
	return {}

# --- SETUP DO MODAL ---
func setup(new_phrases: Array) -> void:
	show_modal(new_phrases)

func show_modal(new_phrases: Array) -> void:
	phrases = new_phrases
	current_index = 0
	visible = true
	next_phrase()

func next_phrase() -> void:
	if current_index < phrases.size():
		content_container.text = phrases[current_index]
		current_index += 1
	else:
		hide_modal()

func hide_modal() -> void:
	visible = false

func _on_click_shield_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled() # bloqueia o clique de passar para trás
		next_phrase()
