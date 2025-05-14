extends StaticBody2D

@export var is_active: bool = true
func toggle() -> void:
	if is_active:
		$Sprite2D.modulate = Color(1,1,1,.2)
		$CollisionShape2D.set_deferred("disabled",true)
	else:
		$Sprite2D.modulate = Color(1,1,1,1)
		$CollisionShape2D.set_deferred("disabled",false)
	is_active = not is_active

func _ready() -> void:
	if not is_active:
		$Sprite2D.modulate = Color(1,1,1,.2)
		$CollisionShape2D.set_deferred("disabled",true)
	else:
		$Sprite2D.modulate = Color(1,1,1,1)
		$CollisionShape2D.set_deferred("disabled",false)
