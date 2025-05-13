extends Button


var region_muted: Rect2 = Rect2(16,16,16,16)
var region_unmuted: Rect2 = Rect2(0,16,16,16) 

func _ready() -> void:
	if AudioServer.is_bus_mute(0):
		icon.region = region_muted
	else: 
		icon.region = region_unmuted


func _toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
	if toggled_on:
		icon.region = region_muted
	else:
		icon.region = region_unmuted
