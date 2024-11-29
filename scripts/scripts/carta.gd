# carta.gd
extends Node2D

signal interaction_started
signal interaction_ended

@onready var content_label = $Label
var player = null
var can_interact = false
var display_time = 7.0
var card_content = "Sé que estás buscando respuestas.
 Ven a mí, donde el río se divide y los árboles
 guardan nuestros secretos. No te detengas.
 ...Te estaré esperando."
@export var fade_in: bool = true  # Si quieres que aparezca con fade in
@export var fade_out: bool = true  # Si quieres que desaparezca con fade out

var tween: Tween

func _ready():
	content_label.text = card_content
	content_label.modulate.a = 0  # Inicialmente transparente
	content_label.hide()
	# Conectar señales del área
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	


func _process(_delta):
	if can_interact and Input.is_action_just_pressed("interact"):
		show_card_content()
		emit_signal("interaction_started")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player = body
		can_interact = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player = null
		can_interact = false
		content_label.hide()
		emit_signal("interaction_ended")

#func show_card_content():
	#content_label.text = card_content
	#content_label.show()
	
	#var timer = get_tree().create_timer(display_time)
	#timer.timeout.connect(_on_display_timer_timeout)

#func _on_display_timer_timeout():
	#content_label.hide()

func show_card_content():
	content_label.text = card_content
	if tween:
		tween.kill()  # Detener tween anterior si existe
	
	content_label.show()
	tween = create_tween()
	
	if fade_in:
		# Fade in
		tween.tween_property(content_label, "modulate:a", 1.0, 0.5)
	else:
		content_label.modulate.a = 1.0
	
	# Esperar el tiempo especificado
	tween.tween_interval(display_time)
	
	if fade_out:
		# Fade out
		tween.tween_property(content_label, "modulate:a", 0.0, 0.5)
	else:
		tween.tween_property(content_label, "modulate:a", 0.0, 0.0)
	
	# Ocultar al terminar
	tween.tween_callback(func(): content_label.hide())

func hide_label():
	if tween:
		tween.kill()
	
	if fade_out:
		tween = create_tween()
		tween.tween_property(content_label, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): content_label.hide())
	else:
		content_label.hide()
		content_label.modulate.a = 0.0
