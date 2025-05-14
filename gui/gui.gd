extends Control




@onready var start: int = Time.get_ticks_msec()
@onready var timer_display: Label = $TimerDisplay
func update_time() -> void:
	var delta_since_start_msec: int = Time.get_ticks_msec()  - start
	@warning_ignore("integer_division")
	var minutes: int = floori(delta_since_start_msec / 60000) % 60
	@warning_ignore("integer_division")
	var seconds: int = floori(delta_since_start_msec / 1000) % 60
	var miliseconds: int = delta_since_start_msec % 1000
	
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
	timer_display.text = time

func _physics_process(_delta: float) -> void:
	update_time()

func _ready() -> void:
	visible = true
	unpause()
	SignalBus.exit.connect(exit)
	$ColorRect2.color.a = 1
	$ColorRect2.visible = true
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($ColorRect2,"color:a",0,.2)

func exit(_level_int: int) -> void:
	pause_menu.visible = false
	h_box_container.visible = false
	$ColorRect2.visible = true
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
	get_tree().call_deferred("change_scene_to_file","res://level_select/level_select.tscn")


func _on_menue_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")

func _on_reset_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")
