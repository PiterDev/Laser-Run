extends Node2D

onready var player = owner.get_node("NewPlayer")

func try_pos():
	return not player.test_move(transform, Vector2(100,0))

func _on_Wall_wall_touched() -> void:
	position = player.position + Vector2(500,0)
	try_pos()
	for y in range(0, 1000, 10):
		position = Vector2(position.x,y)
		if try_pos():
			player.position = position + Vector2(100,0)
			player.glitch_points += 10
			return
			
