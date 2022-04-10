extends Node2D

onready var laser = preload("res://Scenes/Floor 1/EpicLaser.tscn")
onready var player = Game.player

signal laser_glitch

func laser_disappeared(laser):
#	laser.queue_free()
	pass

func player_touched():
	emit_signal("laser_glitch")

func _on_LaserMakeTimer_timeout() -> void:
	var new_laser = laser.instance()
	var player_pos = player.position
	
	new_laser.line_from = Vector2(player_pos.x-400 + Game.random.randi_range(-500, 500), 0)
	add_child(new_laser)
	
	new_laser.connect("disappeared", self, "laser_disappeared")
	new_laser.connect("player_touched", self, "player_touched")
	new_laser.line_to = Vector2(player_pos.x-400 + Game.random.randi_range(-500, 500), 1000)
