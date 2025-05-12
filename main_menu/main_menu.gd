extends Control


func _ready() -> void:
	$VBoxContainer/PlayButton.grab_focus()

func _on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select/level_select.tscn")


func _on_play_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed",load("res://levels/level_1.tscn"))
