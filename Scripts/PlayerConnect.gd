extends Node

func _process(delta: float) -> void:
	get_parent().player_pos = owner.get_node("Player").global_position
