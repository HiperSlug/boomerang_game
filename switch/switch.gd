extends Area2D

var is_on: bool = false
func _on_area_entered(_area: Area2D) -> void:
	if $Switch.animation == "off":
		$Switch.play("on")
	else:
		$Switch.play("off")
