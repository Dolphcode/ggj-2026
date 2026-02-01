extends Control


func _on_start_button_button_up() -> void:
		get_tree().change_scene_to_file("res://game/map.tscn")


func _on_story_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/story_menu.tscn")


func _on_credits_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/credits_menu.tscn")
