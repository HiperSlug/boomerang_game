extends Button


@export var level_scene: PackedScene

func _on_pressed() -> void:
	# NOT GETTING RUN WHEN THE LEVEL_SELECT SCENE IS LOADED FROM ANOTHER SCENE.
	# WORKS WHEN SCENE IS RUN INDEPENDENTLY
	print("stuff")
	#get_tree().change_scene_to_packed(level_scene)


func _pressed() -> void:
	print("stuff")
	#get_tree().change_scene_to_file("res://levels/level_1.tscn")
	#get_tree().change_scene_to_packed(level_scene)
	# Still doesnt work
