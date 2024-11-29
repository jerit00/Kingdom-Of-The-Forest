extends Control


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continuar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Pantalla_de_carga.tscn")
	
func _on_salir_pressed() -> void:
	get_tree().quit()
