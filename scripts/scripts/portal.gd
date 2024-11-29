extends Area2D

@export_file("*.tscn") var siguiente_nivel

func _ready():
	# Verificar configuración
	print("=== Configuración del Portal ===")
	print("Collision Layer: ", collision_layer)
	print("Collision Mask: ", collision_mask)
	print("Monitoring: ", monitoring)
	print("Monitorable: ", monitorable)
	
	# Verificar hijo CollisionShape2D
	var shape = get_node_or_null("CollisionShape2D")
	if shape:
		print("CollisionShape2D encontrado")
		print("Shape habilitado: ", !shape.disabled)
		if shape.shape:
			print("Tipo de forma: ", shape.shape.get_class())
		else:
			push_error("CollisionShape2D no tiene forma asignada!")
	else:
		push_error("Falta el nodo CollisionShape2D!")
	
	# Conectar señales
	body_entered.connect(_on_body_entered)
	print("Señal body_entered conectada")

func _on_body_entered(body: Node2D) -> void:
	print("¡Colisión detectada con: ", body.name)
	print("Grupos del cuerpo: ", body.get_groups())
	
	if body.is_in_group("Player"):
		print("Jugador detectado, cambiando nivel...")
		if siguiente_nivel:
			get_tree().change_scene_to_file(siguiente_nivel)
		else:
			print("Error: siguiente_nivel no configurado")

# Función de debugging para mostrar cuerpos cercanos
func _process(_delta):
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		print("Cuerpos cerca del portal: ", bodies)
