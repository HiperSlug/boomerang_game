extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.death.connect(on_player_death)

func on_player_death() -> void:
	get_tree().reload_current_scene()
