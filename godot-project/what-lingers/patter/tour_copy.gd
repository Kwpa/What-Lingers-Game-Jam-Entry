# The Godot tour demo: play the interactive Patter tour. Mirrors the web / Unity / Unreal tour
# demos: step the flow, offer the choices, and (optionally) play each line's WINNING take via the
# patteraudio.json resolver (PatterAudio) - whatever rung the audio folder holds; no rung is
# hard-coded here.
#
# The bundle ships INSIDE the addon (demo/tour.patterc), so the demo runs straight from the
# downloaded zip. Audio files are NOT bundled (playback is your platform call): inside the
# PatterKit repo the demo picks up the shared scratch takes from examples/projects/audio
# automatically; anywhere else it plays silently unless you point _audio_base at your own
# Patter audio folder.
#
# Open addons/patterplay/demo/tour.tscn and press Play (F6 with the scene focused).
extends Control

# Preloaded by path so the demo also runs headless with a cold class cache.
const PatterAudioScript := preload("res://addons/patterplay/runtime/audio.gd")

var _engine: PatterEngine
var _flow: PatterFlow
var _audio = null  # PatterAudio, or null when the manifest is missing
var _audio_base: String = ""

@onready var _transcript: VBoxContainer = $Layout/TranscriptBG/Scroll/Transcript
@onready var _scroll: ScrollContainer = $Layout/TranscriptBG/Scroll
@onready var _controls: VBoxContainer = $Controls
@onready var _audio_toggle: CheckBox = $Layout/Header/AudioToggle
@onready var _player: AudioStreamPlayer = $AudioPlayer
@onready var _dialogue: Control = $Dialogue
@onready var _next_button: Button = $Next
@onready var _photo: TextureRect = $Background/Photo
@onready var _lines: RichTextLabel = $Dialogue/Lines
@onready var _transcript_bg: TextureRect = $Layout/TranscriptBG
@onready var _lighthouse_button: Button = $Layout/Header/LighthouseButton

@onready var _button_scene: PackedScene = preload("res://scenes/option_button.tscn")

var _audio_enabled : bool = true

func _ready() -> void:
	# The bundle ships with the addon, so the demo runs straight from a downloaded zip.
	var json := FileAccess.get_file_as_string("res://patter/what_lingers.patterc")
	if json == "":
		_append("Bundle missing.")
		return
	var bundle = PatterBundle.load_from_string(json)
	if bundle == null:
		_append("Bundle failed to parse.")
		return
	_engine = PatterEngine.new(bundle)
	
	# Displays global properties as an overlay
	PatterDebug.register(_engine)
	#var panel := PatterStatePanel.new()
	#add_child(panel)

	# Audio is optional and NOT bundled: inside the PatterKit repo the shared scratch takes are
	# picked up automatically; elsewhere, point _audio_base at your own Patter audio folder.
	if _audio_base == "":
		_audio_base = ProjectSettings.globalize_path("res://").path_join("../../examples/projects/audio")
	var manifest := FileAccess.get_file_as_string(_audio_base.path_join("patteraudio.json"))
	if manifest != "":
		_audio = PatterAudioScript.new(manifest, _audio_base)

	_next_button.pressed.connect(_step)
	_start()


func _start() -> void:
	for child in _transcript.get_children():
		child.queue_free()
	_flow = _engine.open_flow("main", "return-to-lighthouse")  # the project's start scene
	_step()


func _step() -> void:
	var step: Dictionary = _flow.advance()
	#print(_flow.get_property("@scene.linger_points")) # get Shelly's linger points
	#print(_flow.get_property("@photo_title")) # get the global photo title
	_update_background()
	match step["type"]:
		"line":
			var who: String = step.get("characterName", step.get("character", ""))
			_append("[b]%s[/b]  %s" % [who.to_upper(), _fmt(step["text"])])
			_play_clip(step["id"])
			_show_next()
		"text":
			_append("[i]%s[/i]" % _fmt(step["text"]))
			_play_clip(step["id"])
			_show_next()
		"gameEvent":
			_append("[color=#8a8069]⚙ game event %s[/color]" % step["id"])
			_show_next()
		"choice":
			_show_choices(step["options"])
		"end":
			_append("[center]· The End ·[/center]")
			_show_restart()


func _update_background() -> void:
	var correct_background = str("res://photos/", _flow.get_property("@photo_title"), ".jpg")
	var current_background: String = _photo.texture.get_path()
	if current_background != correct_background:
		_photo.texture = load(correct_background)


## Fire the beat's winning take, if the manifest resolves one for it.
func _play_clip(beat_id: String) -> void:
	if _audio == null or not _audio_enabled:
		return
	var path: String = _audio.resolve(beat_id)
	if path == "":
		return
	var stream := AudioStreamWAV.load_from_file(path)
	if stream != null:
		_player.stream = stream
		_player.play()


# Patter's formatting markup is a fixed, flat vocabulary (<b>/<i>/<bi>) handed over verbatim;
# mapping it is the host's job. Here: onto BBCode.
func _fmt(s: String) -> String:
	return s.replace("<bi>", "[b][i]").replace("</bi>", "[/i][/b]") \
		.replace("<b>", "[b]").replace("</b>", "[/b]") \
		.replace("<i>", "[i]").replace("</i>", "[/i]")


# Buttons render plain text, so there the tags just come off.
func _plain(s: String) -> String:
	for tag in ["<bi>", "</bi>", "<b>", "</b>", "<i>", "</i>"]:
		s = s.replace(tag, "")
	return s


func _append(bbcode: String) -> void:
	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = bbcode
	_transcript.add_child(label)
	_lines.text = bbcode
	await get_tree().process_frame  # let the label size before jumping to the end
	_scroll.scroll_vertical = int(_scroll.get_v_scroll_bar().max_value)


func _show_next() -> void:
	# _next_button.show()
	var button = _button_scene.instantiate()
	button._set_option("▸ Next", _step)
	_set_controls([button])


func _show_choices(options: Array) -> void:
	var buttons: Array = []
	for o in options:
		var opt: Dictionary = o
		var label: String = _plain(opt.get("text", "(choice)"))
		var button = _button_scene.instantiate()
		button._set_option(label, func() -> void:
			_flow.choose(opt["id"])
			_dialogue.show()
			_clear_controls()
			_step())
		button.disabled = not opt.get("eligible", true)
		buttons.append(button)
	_dialogue.hide()
	_set_controls(buttons)


func _clear_controls():
	for n in _controls.get_children():
		_controls.remove_child(n)
		n.queue_free()


func _show_restart() -> void:
	_set_controls([_button("↺ Play again", _start)])


func _button(label: String, on_pressed: Callable) -> Button:
	var button = _button_scene.instantiate()
	button._set_option(label, on_pressed)
	return button


func _set_controls(buttons: Array) -> void:
	_clear_controls()
	_next_button.hide()
	for b in buttons:
		_controls.add_child(b)


func _show_transcript(state: bool):
	if state:
		_transcript_bg.show()
		_dialogue.hide()
		_lighthouse_button.hide()
		var button = _button_scene.instantiate()
		button._set_option("Close Transcript", func(): _show_transcript(false))
		_set_controls([button])
	else:
		_hide_menu()


func _show_menu():
	_dialogue.hide()
	var transcript_button = _button_scene.instantiate()
	transcript_button._set_option("Show Transcript", func(): _show_transcript(true))
	var return_button = _button_scene.instantiate()
	return_button._set_option("Return to Title", _return_to_title)
	var audio_button = _button_scene.instantiate()
	audio_button._set_option("Toggle Audio", _toggle_audio)
	var close_button = _button_scene.instantiate()
	close_button._set_option("Close Menu", _hide_menu)
	_set_controls([transcript_button, audio_button, return_button, close_button])


func _hide_menu():
	_transcript_bg.hide()
	_dialogue.show()
	_lighthouse_button.show()
	_show_next()


func _toggle_audio():
	_audio_enabled = not _audio_enabled


func _return_to_title():
	print("title")
	pass
