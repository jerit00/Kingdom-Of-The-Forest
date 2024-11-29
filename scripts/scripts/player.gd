extends CharacterBody2D

@export var speed: float = 200
@onready var sprite: AnimatedSprite2D = $Movimientos
@export var salud: int = 100
@export var damage: int = 10
@onready var sword_sprite: AnimatedSprite2D = $Movimientos/Movimientos_s
@export var sword_damage: int = 25
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 50
@export var max_salud: int = 100
@export var salud_maxima: int = 100
@export var salud_actual: int = 100
@export var Item_scene: PackedScene

# Variables para el dash
@export var dash_speed: float = 500  # Velocidad del dash
@export var dash_duration: float = 0.2  # Duración del dash en segundos
@export var dash_cooldown: float = 0.8  # Tiempo de espera entre dashes
var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

# Sistema de interacción
var current_interactable = null
var has_potion: bool = false
var has_sword: bool = false
var can_attack: bool = true
var is_moving: bool = false
@onready var enemy = get_node("../Enemy")

func _ready():
	add_to_group("player")
	sword_sprite.hide()
	# Conectar las señales del área de interacción
	$Hitbox_Player.area_entered.connect(_on_interaction_area_entered)
	$Hitbox_Player.area_exited.connect(_on_interaction_area_exited)
	
	# Crear timer para el dash
	var dash_timer = Timer.new()
	dash_timer.name = "DashTimer"
	dash_timer.one_shot = true
	dash_timer.wait_time = dash_duration
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	add_child(dash_timer)
	
	# Crear timer para el cooldown del dash
	var cooldown_timer = Timer.new()
	cooldown_timer.name = "DashCooldownTimer"
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	add_child(cooldown_timer)

func _physics_process(delta: float) -> void:
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		motion_ctrl()
	
	move_and_slide()

func _on_body_entered(body: CharacterBody2D):
	if body is CharacterBody2D:
		body.recuperar_vida_maxima()
		queue_free()

# Sistema de interacción mejorado
func _on_interaction_area_entered(area: Area2D):
	if area.get_parent().has_method("interact"):
		current_interactable = area.get_parent()
		print("Objeto interactivo detectado")

func _on_interaction_area_exited(area: Area2D):
	if current_interactable == area.get_parent():
		current_interactable = null
		print("Saliendo del área de interacción")

func curar_salud(cantidad: int):
	salud_actual = min(salud_actual + cantidad, salud_maxima)
	print("Salud actual del jugador: ", salud_actual)

func motion_ctrl() -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1

	velocity = velocity.normalized() * speed
	is_moving = velocity != Vector2.ZERO

	# Manejar el dash
	if Input.is_action_just_pressed("ui_dash") and can_dash and velocity != Vector2.ZERO:
		start_dash()
	
	update_animations()
	
	# Sistema de interacción mejorado
	if Input.is_action_just_pressed("interact"):
		if current_interactable != null:
			if current_interactable.has_method("interact"):
				current_interactable.interact()
		elif not has_sword:
			pick_up_sword()

	if Input.is_action_just_pressed("attack") and has_sword and can_attack:
		attack()

func update_animations():
	if is_moving or is_dashing:  # Actualizado para considerar el dash
		if velocity.x > 0:
			sprite.play("derecha")
			if has_sword:
				sword_sprite.play("derecha_s")
		elif velocity.x < 0:
			sprite.play("izquierda")
			if has_sword:
				sword_sprite.play("izquierda_s")
		elif velocity.y > 0:
			sprite.play("abajo")
			if has_sword:
				sword_sprite.play("abajo_s")
		elif velocity.y < 0:
			sprite.play("arriba")
			if has_sword:
				sword_sprite.play("arriba_s")
	else:
		sprite.play("idle")
		if has_sword:
			sword_sprite.play("idle_s")

func start_dash() -> void:
	is_dashing = true
	can_dash = false
	dash_direction = velocity.normalized()
	get_node("DashTimer").start()
	get_node("DashCooldownTimer").start()
	print("Dash ejecutado!")

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity = dash_direction * speed

func _on_dash_cooldown_timeout() -> void:
	can_dash = true
	print("Dash disponible!")

func pick_up_sword():
	var sword = get_node_or_null("../Sword")
	if sword and not has_sword:
		has_sword = true
		print("Espada recogida")
		
		# Ocultar el label si existe
		var sword_label = sword.get_node_or_null("Label")
		if sword_label:
			sword_label.hide()
		
		sword.queue_free()
		sword_sprite.show()
		sprite.play("idle")

func attack():
	print("Atacando con la espada")
	can_attack = false
	
	if enemy and position.distance_to(enemy.position) <= attack_range:
		print("Enemigo en rango, aplicando daño")
		enemy.recibir_daño(sword_damage)
	else:
		print("No hay enemigos en rango")
	
	var timer: Timer = Timer.new()
	timer.wait_time = attack_cooldown
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_attack_timeout)

func _on_attack_timeout():
	can_attack = true

func recibir_daño(cantidad: int):
	salud -= cantidad
	print("Jugador recibió daño. Salud restante: ", salud)
	if salud <= 0:
		morir()

func recuperar_vida(cantidad: int):
	salud += cantidad
	if salud > max_salud:
		salud = max_salud
	print("Vida restaurada al máximo:", salud)

func morir():
	print("El jugador ah muerto", salud)
	get_tree().reload_current_scene()

func _on_portal_body_entered(body: Node2D) -> void:
	pass
