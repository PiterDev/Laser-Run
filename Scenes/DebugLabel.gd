extends Label

func _process(_delta: float) -> void:
	var player = owner.get_node("Player")
	var text_to_set := """
	Velocity: %s
	Ammo: %s
	
	"""
	text = text_to_set % [player.velocity, player.laser_ammo]
