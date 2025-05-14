extends Button


@export var level_scene: PackedScene
@export var level_int: int


func _pressed() -> void:
	get_tree().change_scene_to_packed(level_scene)

func _ready() -> void:
	if level_scene == null:
		disabled = true
		return
	
	if level_int == 1:
		disabled = false
	else:
		var is_last_level_completed: bool = SaveData.completed_levels[level_int - 2] # not minus 1 b/c next lvl
		if is_last_level_completed:
			disabled = false
		else:
			#pass
			disabled = true
	
	var is_collectable_gotten: bool = SaveData.gotten_collectables[level_int - 1]
	if is_collectable_gotten:
		text += "*"
	else:
		pass
