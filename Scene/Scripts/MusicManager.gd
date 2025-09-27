extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var music_tracks := {
	"menu": preload("res://Assets/Music/gameplay_theme.ogg"),
	"gameplay": preload("res://Assets/Music/gameplay_theme.ogg"),
	"store": preload("res://Assets/Music/funky_theme.ogg")
}

func _ready():
	add_child(music_player)
	music_player.connect("finished", Callable(self, "_on_music_finished"))

func play_music(track_name: String):
	if not music_tracks.has(track_name):
		push_error("Track '%s' not found!" % track_name)
		return

	var new_track = music_tracks[track_name]
	if music_player.stream == new_track and music_player.playing:
		return

	music_player.stream = new_track
	music_player.play()

func stop_music():
	if music_player.playing:
		music_player.stop()
		

func _on_music_finished():
	# reinicia automaticamente a música atual
	music_player.play()
