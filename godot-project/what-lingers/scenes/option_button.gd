extends Button

var faded_outline = Vector4(0.2, 0.2, 0.2, 1)
var solid_outline = Vector4(0, 0, 0, 1)

var faded_background = Vector4(0.69, 0.72, 0.81, 1) # #B0B8D0
var solid_background = Vector4(0.88, 0.9, 0.98, 1) # #E0E7FA

func _ready():
	$Image.material = $Image.material.duplicate()


func _set_option(text: String, on_pressed: Callable):
	$Label.text = text
	pressed.connect(on_pressed)


func _fade(state: bool):
	if state:
		# $Image.material.set_shader_parameter("outline_color", faded_outline)
		$Image.material.set_shader_parameter("box_color", faded_background)
	else:
		# $Image.material.set_shader_parameter("outline_color", solid_outline)
		$Image.material.set_shader_parameter("box_color", solid_background)


func fade_on():
	_fade(true)


func fade_off():
	_fade(false)
