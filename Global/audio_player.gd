extends Node
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

# Diccionario de pistas de música por nivel
var music_tracks = {
	"Intro": preload("res://sounds/Musica/Day-of-Night-Alternative-version-_-SILENT-HILL-inspired-music-_.ogg"),
	"Tension": preload("res://sounds/Musica/Dark-Heaven-_-Silent-Hill-Inspired-Music-_.ogg"),
	"Misterio": preload("res://sounds/Musica/What-is-Real-_-SILENT-HILL-inspired-music-_.ogg"),
	"Misterio2": preload("res://sounds/Musica/Smooth-as-Hell-_-SILENT-HILL-inspired-music-_.ogg"),
	"incomodidad": preload("res://sounds/Musica/Footsteps-in-the-Dark-_-SILENT-HILL-inspired-music-_.ogg"),
}

var current_music_track: AudioStreamPlayer = null
var music_stopped: bool = false

func _ready():
	current_music_track = audio_player
	#current_music_track.connect("finished", self, "_on_music_finished")

func play_music(scene_path):
	if music_tracks.has(scene_path):
		# Si la música se está reproduciendo y se cambia la pista, detenerla primero
		if current_music_track.playing:
			current_music_track.stop()
		# Asignar y reproducir la nueva pista
		current_music_track.stream = music_tracks[scene_path]
		current_music_track.play()
		music_stopped = false
	else:
		print("Error: Pista de música no encontrada para la escena: ", scene_path)

func stop_music():
	if current_music_track.playing:
		current_music_track.stop()

func _on_music_finished():
	# Verificar si la música se detuvo y reproducirla nuevamente
	if !music_stopped:
		current_music_track.play()
