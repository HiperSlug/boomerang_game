#@tool
extends TextureRect


@export var fps: int = 10

var accumulated_delta: float = 0

var current_index: int = 0
var atlas_coords: Array[Rect2] = [
	Rect2(0,32,32,32),
	Rect2(32,32,32,32),
	Rect2(64,32,32,32),
	Rect2(96,32,32,32),
]


func _physics_process(delta: float) -> void:
	accumulated_delta += delta
	var period: float = 1/float(fps)
	if accumulated_delta > period:
		accumulated_delta = 0
		current_index += 1
		texture.region = atlas_coords[current_index % atlas_coords.size()]
