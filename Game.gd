extends Node

var score := 0
var high_score := 0 setget change_high_score

const score_path := "res://Resources/scores.json"
var scores: Dictionary = {}

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
	var content_as_text = file.get_as_text()
	var content_as_dictionary = parse_json(content_as_text)
	file.close()
	return content_as_dictionary

func write_json_file(file_path, data):
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func change_high_score(new_score):
	high_score = new_score
	scores["high_score"] = high_score
	write_json_file(score_path, scores)
	print("Write")
