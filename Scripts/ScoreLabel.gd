extends Label

func _process(delta: float) -> void:
	text = str(Game.score)
