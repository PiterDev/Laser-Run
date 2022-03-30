extends Label

func _process(_delta: float) -> void:
	if not Game.player_ready:
		return
	var player = Game.player

	
	var text_to_set := """
	FPS: %s
	
	Velocity: %s
	Ammo: %s
	
	"""

	text = text_to_set % [Engine.get_frames_per_second(), player.velocity, round(player.laser_ammo)]
