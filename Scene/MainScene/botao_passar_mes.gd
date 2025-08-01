extends TextureButton

@onready var animation_player = $AnimationPlayer

func _pressed():
	print("clicou")
	animation_player.play("pulse")
