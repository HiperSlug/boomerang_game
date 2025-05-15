extends Control





@onready var timer_display: Label = $TimerDisplay
func update_time() -> void:
	var time: int = SpeedrunTimer.get_level_time()
	
	time_elapsed = time
	@warning_ignore("integer_division")
	var minutes: int = floori(time / 60000) % 60
	@warning_ignore("integer_division")
	var seconds: int = floori(time / 1000) % 60
	var miliseconds: int = time % 1000
	
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
	
	var time_str: String = minutes_str + ":" + seconds_str + ":" + miliseconds_str
	timer_display.text = time_str

var time_elapsed: int = 0

func _physics_process(_delta: float) -> void:
	if SpeedrunTimer.is_speedrunning:
		update_time()

func _ready() -> void:
	SignalBus.exit.connect(exit)
	
	unpause()
	
	visible = true
	
	$ColorRect2.color.a = 1
	$ColorRect2.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($ColorRect2,"color:a",0,.2)
	
	$TimerDisplay.visible = SpeedrunTimer.is_speedrunning

func exit(_level_int: int, _time_elapsed: float) -> void:
	pause_menu.visible = false
	h_box_container.visible = false
	$ColorRect2.visible = true
	if get_tree() != null:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($ColorRect2,"color:a",1,.2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()

@onready var pause_menu: Control = $PauseMenu
@onready var h_box_container: HBoxContainer = $HBoxContainer

func pause() -> void:
	pause_menu.visible = true
	h_box_container.visible = false
	get_tree().paused = true
	$PauseMenu/HBoxContainer/PauseButton.grab_focus()
	

func unpause() -> void:
	pause_menu.visible = false
	h_box_container.visible = true
	get_tree().paused = false

func _on_level_select_button_pressed() -> void:
	get_tree().paused = false
	SpeedrunTimer.end_speedrun_early()
	get_tree().call_deferred("change_scene_to_file","res://level_select/level_select.tscn")


func _on_menue_button_pressed() -> void:
	get_tree().paused = false
	SpeedrunTimer.end_speedrun_early()
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_reset_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")
