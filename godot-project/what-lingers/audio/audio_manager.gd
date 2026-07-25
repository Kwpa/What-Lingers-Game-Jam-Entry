extends Node

@export var sfx: Dictionary[StringName, AudioStream]

func set_music(music_name: StringName) -> void:
	var stream: AudioStreamInteractive = $MusicAudioStreamPlayer.stream
	var playback: AudioStreamPlaybackInteractive = $MusicAudioStreamPlayer.get_stream_playback()
	var current_stream_name = stream.get_clip_name(playback.get_current_clip_index())
	if current_stream_name != music_name:
		playback.switch_to_clip_by_name(music_name)

func set_ambience(ambience_name: StringName) -> void:
	var stream: AudioStreamInteractive = $AmbienceAudioStreamPlayer.stream
	var playback: AudioStreamPlaybackInteractive = $AmbienceAudioStreamPlayer.get_stream_playback()
	var current_stream_name = stream.get_clip_name(playback.get_current_clip_index())
	if current_stream_name != ambience_name:
		playback.switch_to_clip_by_name(ambience_name)

func play_sfx(sfx_name: StringName) -> void:
	if sfx.has(sfx_name):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		player.stream = sfx[sfx_name]
		add_child(player)
		player.finished.connect(func(): player.queue_free())
		player.play()
