extends Control

# --- NODES ---
@onready var panel = $ModalContainer
@onready var click_shield: ColorRect = $ModalContainer/ClickShield
@onready var background_blur: ColorRect = $BackgroundBlur
@onready var content_container: RichTextLabel = $ModalContainer/ContentContainer
@onready var rodape = $ModalContainer/Rodape
@onready var music_player = $AudioStreamPlayer

# --- VARIÁVEIS ---
var phrases: Array = []
var current_index: int = 0
var main_music_player = null

# --- READY ---
func _ready() -> void:
	visible = false
	
	# Bloqueia todos os cliques atrás do modal
	mouse_filter = Control.MOUSE_FILTER_STOP
	click_shield.mouse_filter = Control.MOUSE_FILTER_STOP
	background_blur.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Permite clicar no shield para avançar a frase
	click_shield.gui_input.connect(_on_click_shield_input)


# --- ABRIR MODAL COM MÚSICA ---
func open_modal(main_player, new_phrases: Array) -> void:
	main_music_player = main_player
	
	# Pausar música principal
	if main_music_player:
		main_music_player.stop()
	
	# Configurar frases
	phrases = new_phrases
	current_index = 0
	
	# Mostrar modal
	visible = true
	
	# Tocar música do lore
	music_player.play()
	
	# Exibir primeira frase
	next_phrase()


# --- FECHAR MODAL ---
func close_modal() -> void:
	# Parar música do lore
	music_player.stop()
	visible = false
	
	# Retomar música principal
	if main_music_player:
		main_music_player.play()

	# Liberar inputs da MainScene
	if get_parent().has_method("_set_input_blocked"):
		get_parent()._set_input_blocked(false)
	
	
# --- AVANÇAR FRASES ---
func next_phrase() -> void:
	if current_index < phrases.size():
		content_container.text = phrases[current_index]
		current_index += 1
	else:
		close_modal()


# --- INPUT DO CLICK SHIELD ---
func _on_click_shield_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled() # bloqueia clique para trás
		next_phrase()


# --- DADOS DE LORE (EXEMPLO) ---
func get_lore_data(lore_id: String) -> Dictionary:
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
	
	if lores.has(lore_id):
		return lores[lore_id]
	return {}
