extends Control

onready var player := owner

var current_num := 0
var playing_glitch := true
onready var audio := player.get_node("Audio").get_node("GlitchSound")
func _on_BeatChecker_timeout() -> void:
	current_num += 1
	if player.glitch_points == 0:
		return
	var check_every: int = (10 - (player.glitch_points / 10)) + 1
	
	if current_num % check_every == 0 and playing_glitch:
		$Flasher.play("Flash")
		audio.pitch_scale = 1.0 + float(player.glitch_points) / 100
		audio.play()


func _on_RotateTimer_timeout() -> void:
	$Rotator.play("Rotate")
	$RotateTimer.wait_time = Game.random.randi_range(12, 16)
	$RotateTimer.start()


func _on_NewPlayer_points_removed() -> void:
	playing_glitch = false
	$GlitchRemove.play("Flash")
	


func _on_GlitchRemove_animation_finished(_anim_name: String) -> void:
	playing_glitch = true
