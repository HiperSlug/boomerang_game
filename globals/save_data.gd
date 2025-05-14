extends Node


var total_level_count: int = 15

var gotten_collectables: Array
var completed_levels: Array

func delete_data() -> void:
	new_data()
	save_data()

func set_level_collectable_as_gotten(level_number: int) -> void:
	gotten_collectables[level_number - 1] = true
	save_data()

func set_level_completed(level_number: int) -> void:
	completed_levels[level_number] = true
	save_data()

func _ready() -> void:
	new_data()
	load_data() # enable when actually playing
	SignalBus.exit.connect(set_level_completed)

func save_data() -> void:
	var save_file: FileAccess = FileAccess.open("user://save_file.save", FileAccess.WRITE)
	var json_collectables = JSON.stringify(gotten_collectables)
	save_file.store_line(json_collectables)
	var json_completion = JSON.stringify(gotten_collectables)
	save_file.store_line(json_completion)
	
	#print(completed_levels)
	#print(gotten_collectables)

func load_data() -> void:
	if not FileAccess.file_exists("user://save_file.save"):
		return
	
	var save_file: FileAccess = FileAccess.open("user://save_file.save", FileAccess.READ)
	var json: JSON = JSON.new()
	
	var collectables_line: String = save_file.get_line()
	json.parse(collectables_line)
	gotten_collectables = json.data
	
	var completed_line: String = save_file.get_line()
	json.parse(completed_line)
	completed_levels = json.data

func new_data() -> void:
	gotten_collectables.resize(total_level_count)
	completed_levels.resize(total_level_count)
	gotten_collectables.fill(false)
	completed_levels.fill(false)
