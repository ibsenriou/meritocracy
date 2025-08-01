extends TextureButton

func _pressed():
	var atual = get_parent()
	while atual and not atual.is_in_group("fechavel"):
		atual = atual.get_parent()

	if atual:
		atual.queue_free()

		# Reexibe o menu principal
		var main_scene = get_tree().get_root().get_node("MainScene")
		if main_scene:
			main_scene.show()

			# Faz o botão aparecer de novo manualmente
			var botao_mes = main_scene.get_node_or_null("BotaoPassarMes")
			if botao_mes:
				botao_mes.visible = true
				botao_mes.disabled = false
