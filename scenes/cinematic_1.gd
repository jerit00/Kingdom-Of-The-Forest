extends ColorRect
@onready var text_label: RichTextLabel = $RichTextLabel
var text_to_display = "Aquí estoy... Draven Blackthorn, reducido a una sombra, vagando sin rumbo entre recuerdos que apenas sé si son reales. Encontré la carta, escrita con la mano de mi esposa... me pide que la busque. Pero, ¿y si solo es un engaño de mi propia mente rota?
Esta carta es lo único que me queda, el único hilo que me ata a una vida que apenas recuerdo. Si ella vive, tal vez haya redención. Si no... tal vez solo sea otra trampa de mi delirio. Pero aún así, seguiré adelante. Un día más, un paso más. Hasta encontrar la verdad...o la locura completa."
var typing_speed = 0.06  # Tiempo entre cada letra
func _ready():
	# Mostrar el fondo negro
	color = Color.BLACK

	# Comenzar a escribir el texto
	display_text()

	AudioPlayer.play_music("Intro")

func display_text():
	text_label.text = ""

	# Escribir el texto letra por letra
	for i in range(len(text_to_display)):
		text_label.text += text_to_display[i]
		await get_tree().create_timer(typing_speed).timeout

	# Esperar 5 segundos y terminar la cinemática
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
