extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()

@onready var pause_menu: Control = $PauseMenu

func pause() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	$PauseMenu/HBoxContainer/PauseButton.grab_focus()

func unpause() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _on_level_select_button_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file","res://level_select/level_select.tscn")


func _on_menue_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_reset_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")
