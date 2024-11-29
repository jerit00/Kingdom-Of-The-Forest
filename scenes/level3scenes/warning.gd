extends Area2D

@export var display_time: float = 5.0  # Tiempo en segundos que se mostrará el label
@export var label_text: String = "Porque volverias??
Ya no hay vuela atras..
Continua tu camino"  # Texto que mostrará el label
@export var fade_in: bool = true  # Si quieres que aparezca con fade in
@export var fade_out: bool = true  # Si quieres que desaparezca con fade out

@onready var label = $Label
var tween: Tween

func _ready():
	# Conectar señales
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Configurar label
	label.text = label_text
	label.modulate.a = 0  # Inicialmente transparente
	label.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		show_label()

func _on_body_exited(body):
	if body.is_in_group("player"):
		hide_label()

func show_label():
	if tween:
		tween.kill()  # Detener tween anterior si existe
	
	label.show()
	tween = create_tween()
	
	if fade_in:
		# Fade in
		tween.tween_property(label, "modulate:a", 1.0, 0.5)
	else:
		label.modulate.a = 1.0
	
	# Esperar el tiempo especificado
	tween.tween_interval(display_time)
	
	if fade_out:
		# Fade out
		tween.tween_property(label, "modulate:a", 0.0, 0.5)
	else:
		tween.tween_property(label, "modulate:a", 0.0, 0.0)
	
	# Ocultar al terminar
	tween.tween_callback(func(): label.hide())

func hide_label():
	if tween:
		tween.kill()
	
	if fade_out:
		tween = create_tween()
		tween.tween_property(label, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): label.hide())
	else:
		label.hide()
		label.modulate.a = 0.0
