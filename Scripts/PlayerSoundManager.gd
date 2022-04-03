extends Node

func _on_Player_shooting_stopped() -> void:
	$LaserSound.playing = false

func _on_Player_shooting_started() -> void:
	$LaserSound.playing = true
