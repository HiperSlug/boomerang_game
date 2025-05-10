extends StaticBody2D

var is_active: bool = true
func _on_switch_area_entered(_area: Area2D) -> void:
	if is_active:
		$Sprite2D.modulate = Color(1,1,1,.2)
		$CollisionShape2D.set_deferred("disabled",true)
	else:
		$Sprite2D.modulate = Color(1,1,1,1)
		$CollisionShape2D.set_deferred("disabled",false)
	is_active = not is_active
