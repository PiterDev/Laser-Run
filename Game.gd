extends Node

var score := 0
var high_score := 0 setget change_high_score

const score_path := "user://laser_run_scores.json"
var scores := {}

func _ready() -> void:
	scores = read_json_file(score_path)
	print(scores)
	high_score = scores["high_score"]
	print(scores["high_score"])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		
func read_json_file(file_path):
	var file = File.new()
	file.open(file_path, File.READ)
#	write_json_file(score_path, '{"high_score": 0}')
	if not file.file_exists(score_path):
		write_json_file(score_path, {"high_score": 0})
		return {"high_score": 0}
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	file.close()
	return content_as_dictionary

func write_json_file(file_path, data):
	var file = File.new()
	if file.open(file_path, File.WRITE) != 0:
		print("Failed to write data.")
		return
	
	file.store_line(to_json(data))
	file.close()
	print("Data sent!")


func change_high_score(new_score):
	high_score = new_score
	scores["high_score"] = high_score
