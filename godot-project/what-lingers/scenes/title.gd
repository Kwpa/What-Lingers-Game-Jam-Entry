extends Control

@export var _speed: float = 0.5

@onready var _game_scene: PackedScene = load("res://patter/what_lingers.tscn")

func _ready() -> void:
	$TitleBackground.modulate = Color(0, 0, 0, 0)
	$LighthouseButton.modulate = Color(1, 1, 1, 0)
	$TitleBackground/TitleText.modulate = Color(1, 1, 1, 0)
	$Controls.modulate = Color(1, 1, 1, 0)
	$Controls/OptionButton.disabled = true


func _process(delta: float) -> void:
	delta = delta * _speed
	if $LighthouseButton.modulate.a < 1:
		var alpha = $LighthouseButton.modulate.a
		$LighthouseButton.modulate = Color(1, 1, 1, alpha + delta)
	elif $TitleBackground.modulate.a < 1:
		var alpha = $TitleBackground.modulate.a
		$TitleBackground.modulate = Color(0, 0, 0, alpha + delta)
		$TitleBackground/TitleText.modulate = Color(1, 1, 1, alpha + delta)
	elif $Controls.modulate.a < 1:
		var alpha = $Controls.modulate.a
		$Controls.modulate = Color(1, 1, 1, alpha + delta)
	else:
		$Controls/OptionButton.disabled = false


func _begin() -> void:
	get_tree().change_scene_to_packed(_game_scene)
