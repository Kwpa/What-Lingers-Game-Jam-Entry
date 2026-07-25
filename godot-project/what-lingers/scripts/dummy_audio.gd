extends Node

var debug_on := false

func _ready() -> void:
	Events.connect("oneshot_sfx", oneshot_sfx)
	Events.connect("fadein_loop_sfx", fadein_loop)
	Events.connect("fadeout_loop_sfx", fadeout_loop)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_K:
			debug_on = !debug_on
			$Label1.visible = debug_on
			$Label2.visible = debug_on
			$Label3.visible = debug_on
			if debug_on:
				$Label1.text = "debug on for game events"
				await get_tree().create_timer(.6).timeout
				$Label1.text = ""
	

func oneshot_sfx(clip_name : String):
	$Label1.text = "oneshot " + clip_name
	await get_tree().create_timer(1).timeout
	$Label1.text = ""

func fadein_loop(clip_name : String):
	$Label2.text = "fade in " + clip_name
	await get_tree().create_timer(1).timeout
	$Label2.text = ""

func fadeout_loop(clip_name : String):
	$Label3.text = "fade out " +clip_name
	await get_tree().create_timer(1).timeout
	$Label3.text = ""
