extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().call_deferred("reload_current_scene")

func _ready() -> void:
	SignalBus.death.connect(on_player_death)
	SignalBus.add_boomerang_to_level.connect(on_boomerang_thrown)
	

func on_player_death() -> void:
	await get_tree().create_timer(.2).timeout # technically this must be manually synced with the player however it doesnt matter
	get_tree().call_deferred("reload_current_scene")


func on_boomerang_thrown(boomerang: Boomerang) -> void:
	add_child(boomerang)
