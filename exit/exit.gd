extends Area2D

@export var next_level: PackedScene
@export var level_int: int
@export var gui: Control

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if next_level != null:
			SignalBus.exit.emit(level_int - 1, gui.time_elapsed)
			if get_tree() != null:
				await get_tree().create_timer(.2).timeout
			get_tree().change_scene_to_packed(next_level)
			#get_tree().call_deferred("change_scene_to_packed",next_level)
		else:
			SignalBus.exit.emit(level_int - 1, gui.time_elapsed)
