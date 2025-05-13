extends Area2D


@export var level_number: int

var regions: Array[Rect2] = [
	Rect2(32,0,16,16),
	Rect2(32,16,16,16),
	Rect2(32,32,16,16),
	Rect2(32,48,16,16),
]

func _ready() -> void:
	var already_collected: bool = SaveData.gotten_collectables[level_number - 1]
	$Sprite2D.texture.region = regions.pick_random()
	
	if already_collected:
		$Sprite2D.modulate.a = .2
		monitoring = false
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimationPlayer.stop()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SaveData.set_level_collectable_as_gotten(level_number)
		$Collect.play()
		$CollisionShape2D.set_deferred("disabled",true)
		$Sprite2D.modulate.a = .2
		$AnimationPlayer.stop()
