extends AudioStreamPlayer
@onready var tween: Tween

const level_music = preload("res://Assets/Audio/theme.wav")
const ending_music = preload("res://Assets/Audio/Ending.wav")


func _play_music(music: AudioStream, volume = -8.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(level_music)

func play_music_end():
	_play_music(ending_music)
	
func stop_music():
	_fade_out(self)

func _fade_out(audio_to_fade: AudioStreamPlayer, fade_duration: float = 2.0, auto_stop: bool = true) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(audio_to_fade, "volume_db", -80, fade_duration) #Turn down the volume to -80dB.
	#Optional, as it might no be ideal to stop the audio in some use cases.
	if auto_stop:
		tween.tween_property(audio_to_fade, "playing", false, 0.0)
