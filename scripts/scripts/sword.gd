extends Node2D  # Changed to Area2D for collision detecstion

signal sword_picked_up

var is_player_in_area = false
var player = null

@onready var pickup_sound = $PickupSound

func _ready():
	# Connect the body_entered and body_exited signals
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		is_player_in_area = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		is_player_in_area = false
		player = null

func _input(event):
	# Check if the player is in the area and presses the interact button
	if is_player_in_area and event.is_action_pressed("interact"):
		if player:
			player.pick_up_sword()  # Call pickup method in player script
			pickup_sound.play()
			emit_signal("sword_picked_up")
			queue_free()  # Remove sword from the scene
