extends Control

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		visible = not visible


func _on_SpeedEdit_text_entered(new_text: String) -> void:
	Game.player.speed = int(new_text)
	$SpeedEdit.release_focus()


func _on_JumpSpeedEdit_text_entered(new_text: String) -> void:
	Game.player.jump_speed = int(new_text)
	$JumpSpeedEdit.release_focus()
