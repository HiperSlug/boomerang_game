extends Control


func _ready() -> void:
	$GridContainer/LevelSelectButton.grab_focus()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_level_select_button_pressed() -> void:
	SpeedrunTimer.start_speedrun()
