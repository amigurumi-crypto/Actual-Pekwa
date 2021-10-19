extends Node

const SAVE_DATA_PATH = "user://save_data.json"
var default_save_data = {
	highscore = 550,
	bkg_playing = true,
	effects_playing = true
}

var current_file


func _ready():
	current_file = load_data_from_file()
#	current_file = default_save_data
#	save_data_to_file()

func save_data_to_file():
	var json_string = to_json(current_file)
	var save_file = File.new()
	save_file.open(SAVE_DATA_PATH, File.WRITE)
	save_file.store_line(json_string)
	save_file.close()

func load_data_from_file():
	var save_file = File.new()
	if not save_file.file_exists(SAVE_DATA_PATH):
		return default_save_data
	
	save_file.open(SAVE_DATA_PATH, File.READ)
	var save_data = parse_json(save_file.get_as_text())
	save_file.close()
	return save_data
