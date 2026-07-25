extends Control


func _on_music_background_button_pressed() -> void:
	AudioManager.set_music("music_background")


func _on_music_ghost_button_pressed() -> void:
	AudioManager.set_music("music_ghost")


func _on_music_credits_button_pressed() -> void:
	AudioManager.set_music("music_credits")


func _on_music_menu_button_pressed() -> void:
	AudioManager.set_music("music_menu")


func _on_no_music_button_pressed() -> void:
	AudioManager.set_music("silent")


func _on_sea_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_sea")


func _on_cliff_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_cliff_face")


func _on_town_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_in_town")


func _on_smoke_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_smoke_break")


func _on_keepers_house_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_site_keepers_house")


func _on_lighthouse_int_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_lighthouse_interior")


func _on_lighthouse_ext_ambience_button_pressed() -> void:
	AudioManager.set_ambience("amb_lighthouse_exterior")


func _on_no_ambience_button_pressed() -> void:
	AudioManager.set_ambience("silent")
	

func _on_ghost_appears_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_ghost_appears")


func _on_footstep_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_footsteps")


func _on_lingers_pos_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_lingers_chime_pos")


func _on_lingers_neg_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_lingers_chime_neg")


func _on_moves_on_pos_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_moves_on_chime_pos")


func _on_moves_on_neg_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_moves_on_chime_neg")


func _on_button_click_sfx_button_pressed() -> void:
	AudioManager.play_sfx("sfx_button_press")
