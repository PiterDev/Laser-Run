extends Label

func _ready() -> void:
	text = "High Score: "  + str(Game.high_score)
