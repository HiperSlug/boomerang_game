extends Area2D

@export var next_level: PackedScene



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if next_level != null:
			get_tree().change_scene_to_packed(next_level)
		else:
			printerr("no level assigned to exit")
