extends Control


func _ready() -> void:
	var final_time: int = SpeedrunTimer.get_final_time()
	
	
	@warning_ignore("integer_division")
	var minutes: int = floori(final_time / 60000) % 60
	@warning_ignore("integer_division")
	var seconds: int = floori(final_time / 1000) % 60
	var miliseconds: int = final_time % 1000
	
	var minutes_str: String = str(minutes)
	if minutes < 10:
		minutes_str = "0" + minutes_str
	var seconds_str: String = str(seconds)
	if seconds < 10:
		seconds_str = "0" + seconds_str
	var miliseconds_str: String = str(miliseconds)
	if miliseconds < 10:
		miliseconds_str = "00" + miliseconds_str
	elif miliseconds < 100:
		miliseconds_str = "0" + miliseconds_str
	
	var time: String = minutes_str + ":" + seconds_str + ":" + miliseconds_str
	$FinalTimeDisplay.text = time


func _input(event: InputEvent) -> void:
	if not event.is_echo() and event.is_pressed():
		SpeedrunTimer.end_speedrun_early()
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
