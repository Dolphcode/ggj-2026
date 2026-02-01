extends Control


func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/main_game.tscn")
	AudioManager.get_node("ButtonClick").play()


func _on_story_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/story_menu.tscn")
	AudioManager.get_node("ButtonClick").play()
	AudioManager.get_node("Narrator").play()
	AudioManager.get_node("Music").volume_db = linear_to_db(0.5)


func _on_credits_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/credits_menu.tscn")
	AudioManager.get_node("ButtonClick").play()



func _on_help_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/help_menu.tscn")
	AudioManager.get_node("ButtonClick").play()
