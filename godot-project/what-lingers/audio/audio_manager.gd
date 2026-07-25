extends Node

@export var sfx: Dictionary[StringName, AudioStream]

@export var music_volume_offset: Dictionary[StringName, float]
@export var ambience_volume_offset: Dictionary[StringName, float]
@export var sfx_volume_offset: Dictionary[StringName, float]

@export var volume_offset_tween_time: float = 2.5

func set_music(music_name: StringName) -> void:
	var playback: AudioStreamPlaybackInteractive = $MusicAudioStreamPlayer.get_stream_playback()
	playback.switch_to_clip_by_name(music_name)
	var volume_offset: float = 0
	if music_volume_offset.has(music_name):
		volume_offset = music_volume_offset[music_name]
	get_tree().create_tween().tween_property(
		$MusicAudioStreamPlayer,
		"volume_db",
		volume_offset,
		volume_offset_tween_time
	)

func set_ambience(ambience_name: StringName) -> void:
	var playback: AudioStreamPlaybackInteractive = $AmbienceAudioStreamPlayer.get_stream_playback()
	playback.switch_to_clip_by_name(ambience_name)
	var volume_offset: float = 0
	if ambience_volume_offset.has(ambience_name):
		volume_offset = ambience_volume_offset[ambience_name]
	get_tree().create_tween().tween_property(
		$AmbienceAudioStreamPlayer,
		"volume_db",
		volume_offset,
		volume_offset_tween_time
	)
		

func play_sfx(sfx_name: StringName) -> void:
	if sfx.has(sfx_name):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		player.stream = sfx[sfx_name]
		if sfx_volume_offset.has(sfx_name):
			player.volume_db = sfx_volume_offset[sfx_name]
		add_child(player)
		player.finished.connect(func(): player.queue_free())
		player.play()
