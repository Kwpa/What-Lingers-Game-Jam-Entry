extends Control

func _ready() -> void:
	Events.connect("remove_fog", remove_fog)
	Events.connect("return_fog", return_fog)
	

func remove_fog():
	var fog_tween = create_tween().tween_property($Fog, "self_modulate",Color(1,1,1,0), 1)
	var darkness_tween = create_tween().tween_property($Darkness, "self_modulate",Color(1,1,1,0), 0)
	

func return_fog():
	var fog_tween = create_tween().tween_property($Fog, "self_modulate",Color(1,1,1,1), 1)
	var darkness_tween = create_tween().tween_property($Darkness, "self_modulate",Color(1,1,1,1), 0)
