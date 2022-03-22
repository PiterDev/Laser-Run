extends Timer

func _ready() -> void:
	Game.score = 0

func _on_ScoreTimer_timeout() -> void:
	Game.score += 1
	if Game.score > Game.high_score:
		Game.high_score = Game.score
