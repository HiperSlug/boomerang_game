extends Node

var is_speedrunning: bool = false
var level_times: Array[int]

var final_level: int = 9
func start_speedrun() -> void: # called upon pressing start button or starting level 1.
	is_speedrunning = true
	level_times.resize(10)
	level_times.fill(0)
	start_level_timer()


func end_speedrun_early() -> void: # called when leaving to menu or level select
	is_speedrunning = false
	level_times.resize(0)


var start_time: int
func start_level_timer() -> void:
	start_time = Time.get_ticks_msec()
func get_level_time() -> int:
	return Time.get_ticks_msec()  - start_time


func _ready() -> void:
	SignalBus.exit.connect(on_level_exit)

func on_level_exit(level_int: int, elapsed_time: int) -> void:
	start_level_timer()
	
	if is_speedrunning:
		level_times[level_int] = elapsed_time
	
	if level_int == final_level:
		get_tree().call_deferred("change_scene_to_file","res://speedrun_finished/speedrun_finished.tscn")

func get_final_time() -> int:
	var final_time: int = 0
	for time: int in level_times:
		final_time += time
	return final_time
