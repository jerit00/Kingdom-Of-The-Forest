extends CharacterBody2D

@export var speed: float = 150
@export var attack_range: float = 0  # Rango de ataque ajustado para detenerse antes
@export var damage: int = 20
@export var attack_cooldown: float = 2.0  # Tiempo entre ataques
@export var salud: int = 100
@export var wait_time_before_chase: float = 8.0  # Tiempo de espera antes de perseguir al jugador
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var Item_scene: PackedScene  # Referencia a la escena de la poción u objeto de recuperación


# Variables de estado
var player: CharacterBody2D  # Referencia al jugador
var can_attack: bool = true
var is_chasing: bool = false  # Indica si el enemigo está persiguiendo al jugador
var is_attacking: bool = false  # Indica si el enemigo está atacando

# Función ready
func _ready():
	player = get_parent().get_node("Player")  # Asegúrate de que la ruta sea correcta
	$CollisionShape2D/Hitbox_Enemy.body_entered.connect(_on_collision_with_player)

	# Temporizador para esperar antes de empezar la persecución
	var wait_timer: Timer = Timer.new()
	wait_timer.wait_time = wait_time_before_chase
	wait_timer.one_shot = true
	add_child(wait_timer)
	wait_timer.start()
	wait_timer.timeout.connect(_on_wait_timer_timeout)

# Iniciar la persecución después del tiempo de espera
func _on_wait_timer_timeout():
	is_chasing = true  # El enemigo empieza a perseguir al jugador
	print("El enemigo ha comenzado a perseguir al jugador.")

# Función de ataque
func start_attack():
	if can_attack:
		is_attacking = true  # Detenemos al enemigo mientras ataca
		velocity = Vector2.ZERO  # Detener al enemigo
		$AnimatedSprite2D.play("ataque")  # Cambia la animación a ataque
		attack()  # Llamar a la función de ataque

# Función que se ejecuta cada frame
func _physics_process(delta: float) -> void:
	if is_chasing and player and not is_attacking:
		follow_and_attack(player, delta)

	# Cambiar la animación según el movimiento
	if velocity.length() > 0 and not is_attacking:
		if sprite.animation != "caminar":
			$AnimatedSprite2D.play("caminar")
	else:
		if sprite.animation != "Idle" and not is_attacking:
			$AnimatedSprite2D.play("Idle")

	# Mover al enemigo sin gravedad
	move_and_slide()

# Función para seguir y atacar al jugador
func follow_and_attack(target: CharacterBody2D, delta: float):
	var direction: Vector2 = (target.position - position).normalized()
	var distance: float = position.distance_to(target.position)

	if distance > attack_range and not is_attacking:
		# Sigue al jugador si está fuera del rango de ataque
		velocity = direction * speed
	else:
		# Detenerse para atacar cuando está dentro del rango
		velocity = Vector2.ZERO
		if can_attack:
			start_attack()

# Función para quitar vida al jugador
func attack():
	if player and player is CharacterBody2D:
		player.recibir_daño(damage)  # Asegúrate de que este método exista en el jugador
		
		# Evitar ataques consecutivos inmediatos
		can_attack = false

		# Crear un temporizador para el cooldown del ataque
		var timer: Timer = Timer.new()
		timer.wait_time = attack_cooldown
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.timeout.connect(_on_attack_timeout)

		print("Enemigo atacando al jugador.")

# Restablecer la capacidad de atacar después del cooldown
func _on_attack_timeout():
	can_attack = true
	is_attacking = false  # El enemigo puede moverse de nuevo

# Función para detectar la colisión con el jugador
func _on_collision_with_player(body: Node):
	if body == player:
		# Iniciar el ataque al colisionar con el jugador
		start_attack()

# Función para que el enemigo reciba daño
func recibir_daño(cantidad: int):
	salud -= cantidad  # Reducimos la salud del enemigo según la cantidad de daño recibido
	print("Enemigo recibió daño. Salud restante: ", salud)
	if salud <= 0:
		morir()

func drop_item() -> void:
	var item := Item_scene.instantiate()
	item.position = position  # Posición del enemigo
	get_parent().add_child(item)  # Agregar la poción a la escena


# Función para manejar la muerte del enemigo
func morir():
	drop_item()
	print("El enemigo ha muerto.")
	#$AnimatedSprite2D.play("muerte")
	
	queue_free()  # Elimina al enemigo de la escena
