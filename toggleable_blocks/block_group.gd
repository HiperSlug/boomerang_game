extends Node2D

@export var start_toggled: bool = false

func _on_switch_area_entered(_area: Area2D) -> void:
	for child in get_children():
		child.toggle()

func _ready() -> void:
	if start_toggled:
		for child in get_children():
			child.toggle()
