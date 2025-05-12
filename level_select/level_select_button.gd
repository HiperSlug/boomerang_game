extends Button


@export var level_scene: PackedScene

func _pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)
