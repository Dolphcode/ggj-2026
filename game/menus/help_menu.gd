extends Control


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://game/menus/main_menu.tscn")
