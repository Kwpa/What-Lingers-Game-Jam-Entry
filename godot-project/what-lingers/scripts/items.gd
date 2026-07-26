extends Control

var store_control : Control

func _ready() -> void:
	Events.connect("show_item", _show_item)
	Events.connect("hide_item", _hide_item)
	

func _show_item(item_name: String):
	match item_name:
		"LIGHTER":
			store_control = $lighter
			pass
		"KEY":
			store_control = $key
			pass
		"VIAL":
			store_control = $vial
			pass
	store_control.visible = true


func _hide_item():
	store_control.visible = false
