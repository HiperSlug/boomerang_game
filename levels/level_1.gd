extends Node2D


func _ready() -> void:
	SignalBus.death.connect(on_player_death)
	SignalBus.add_boomerang_to_level.connect(on_boomerang_thrown)


func on_player_death() -> void:
	get_tree().reload_current_scene()


func on_boomerang_thrown(boomerang: Boomerang) -> void:
	add_child(boomerang)
