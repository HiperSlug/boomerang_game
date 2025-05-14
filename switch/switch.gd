extends Area2D


@export var toggled: bool = false

func _ready() -> void:
	if toggled:
		$Switch.frame = 3
	else:
		$Switch.frame = 0

func _on_area_entered(_area: Area2D) -> void:
	$AudioStreamPlayer2D.play()
	if toggled:
		$Switch.play_backwards("toggle")
	else:
		$Switch.play("toggle")
	toggled = not toggled
