extends Node

func _ready() -> void:
	Events.connect("oneshot_sfx", oneshot_sfx)
	Events.connect("fadein_loop_sfx", oneshot_sfx)
	Events.connect("fadeout_loop_sfx", oneshot_sfx)
	

func oneshot_sfx(clip_name : String):
	$Label1.text = clip_name
	await get_tree().create_timer(1)
	$Label1.text = ""

func fadein_loop(clip_name : String):
	$Label2.text = clip_name
	await get_tree().create_timer(1)
	$Label2.text = ""

func fadeout_loop(clip_name : String):
	$Label3.text = clip_name
	await get_tree().create_timer(1)
	$Label3.text = ""
