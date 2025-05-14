extends TileMapLayer

var speed: float = 16 * 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(delta)
	position.x -= speed * delta * scale.x
	
	if floori(position.x * scale.x) % 16 == 0:
		position.x = 0
	
