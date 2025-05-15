#@tool
extends Control

@export var paused: bool = false

var tile_size: int = 128
var speed: float = tile_size * 3


func _process(delta: float) -> void:
	if paused:
		return
	position.x -= speed * delta
	if position.x < - tile_size:
		position.x += tile_size
	
