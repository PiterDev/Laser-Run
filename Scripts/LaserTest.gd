extends Node2D



func _on_Timer_timeout() -> void:
	var laser = $EpicLaser
	laser.line_from = $pos1.global_position
	laser.line_to = $pos2.global_position
