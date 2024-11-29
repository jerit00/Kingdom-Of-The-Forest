extends Node

func _ready():
	#cambiar_escena()
	interpolar_propiedades()
	#interpolar_funcion()

func interpolar_propiedades() -> void:
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(funcion_interpolada, 0, 15, 3)
	tween.parallel().tween_property(self, "modulate", Color.RED, 3)
	tween.tween_property(self, "scale", Vector2(), 1)
	tween.tween_callback(cambiar_escena)

func interpolar_funcion() -> void:
	var  tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(funcion_interpolada, 0, 10, 1).set_delay(2)
	#tween.stop()
func funcion_interpolada(valor : int) -> void:
	$Control/Label.text = "cargando: " + str(valor)

func cambiar_escena():
	var packed = load("res://scenes/Cinematic1.tscn")
	get_tree().change_scene_to_packed(packed)
