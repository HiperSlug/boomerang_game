extends Button



func _ready() -> void:
	if is_inside_tree():
		 
		if AudioServer.is_bus_mute(0):
			text = "m"
		else:
			text = "M"

func _pressed() -> void:
	AudioServer.set_bus_mute(0,not AudioServer.is_bus_mute(0))
	if AudioServer.is_bus_mute(0):
		text = "m"
	else:
		text = "M"
