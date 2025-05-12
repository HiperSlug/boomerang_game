extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func pause() -> void:
	visible = true
	get_tree().paused = true
	$HBoxContainer/PauseButton.grab_focus()


func unpause() -> void:
	visible = false
	get_tree().paused = false


func _on_level_select_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://level_select/level_select.tscn")
