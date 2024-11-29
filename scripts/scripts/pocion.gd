extends Area2D

var jugador_dentro = false  # Variable para saber si el jugador está en el área

func _ready():
	# Conectar señales al método correspondiente
	self.body_entered.connect(_on_Area2D_body_entered)
	self.body_exited.connect(_on_Area2D_body_exited)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		jugador_dentro = true  # El jugador está en el área
	print("Jugador ha entrado en el área de la poción.")
func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		jugador_dentro = false  # El jugador salió del área
	print("Jugador ha salido del área de la poción.")
func _process(delta):
	if jugador_dentro and Input.is_action_just_pressed("interact"):  # Presiona "E"
		curar_jugador()
		queue_free()  # Elimina la poción
func curar_jugador():
	var jugador = get_tree().get_root().get_node("Node2D/Player")
	if jugador:
		jugador.vida_actual = jugador.vida_maxima  # Cura toda la vida del jugador
	print("El jugador se ha curado.")
