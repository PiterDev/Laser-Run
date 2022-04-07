extends Node


func _on_Update_timeout() -> void:
	var player = Game.player
	var current_score = int((player.position.x-1920) / 10)
#	if player.velocity.x > 300:
#		current_score += 5
#	if player.velocity.y < -300:
#		current_score += 5 

	if current_score > Game.score:
		Game.score = current_score
