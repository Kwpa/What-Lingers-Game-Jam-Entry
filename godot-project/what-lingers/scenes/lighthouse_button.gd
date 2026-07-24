extends Button

@onready var _light : TextureRect = $Light

func _show_light():
	_light.show()


func _hide_light():
	_light.hide()
