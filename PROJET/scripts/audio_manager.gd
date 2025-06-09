extends Node

@onready var music_player := $AudioStreamPlayer

var fade_time := 1.5  # Durée du fondu en secondes
var fade_speed := 1.0 / fade_time
var _fade_out := false
var _fade_in := false
var _target_stream: AudioStream = null

func _process(delta):
	if _fade_out:
		music_player.volume_db -= fade_speed * delta * 60
		if music_player.volume_db <= -80:
			music_player.volume_db = -80
			music_player.stop()
			_fade_out = false
			_play_fade_in()

	elif _fade_in:
		music_player.volume_db += fade_speed * delta * 60
		if music_player.volume_db >= 0:
			music_player.volume_db = 0
			_fade_in = false

func play_music(stream: AudioStream):
	if music_player.stream == stream:
		return  # ne rien faire si c'est déjà la même

	# Si une musique est déjà jouée, lancer un fade out
	if music_player.playing:
		_target_stream = stream
		_fade_out = true
	else:
		music_player.stream = stream
		music_player.volume_db = -80
		music_player.play()
		_fade_in = true

func _play_fade_in():
	if _target_stream:
		music_player.stream = _target_stream
		music_player.volume_db = -80
		music_player.play()
		_fade_in = true
		_target_stream = null

func stop_music():
	_fade_out = true
	_target_stream = null
