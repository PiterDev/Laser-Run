extends Node

var score := 0
var high_score := 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		
