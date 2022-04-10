extends Node2D

onready var player = owner.get_node("NewPlayer")

func try_pos():
	return not player.test_move(transform, Vector2(100,0))

func glitch(dist: int):
	position = player.position + Vector2(dist,0)
	try_pos()
	for y in range(200, 800, 10):
		position = Vector2(position.x,y)
		if try_pos():
			player.position = position + Vector2(100,0)
			player.glitch_points += 10
			player.laser_ammo += 20
			return
func _on_Wall_wall_touched() -> void:
	glitch(500)
			


func _on_LaserSpawner_laser_glitch() -> void:
	glitch(500)
