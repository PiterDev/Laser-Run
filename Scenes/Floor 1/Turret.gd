extends Node2D

var player_in_proximity := false

onready var player = Game.player
onready var raycast = $Polygon2D/RotatingPart/RayCast2D
onready var line = $Polygon2D/RotatingPart/SmallLine

var shot := false



func set_point(pos: Vector2):
	$Polygon2D/RotatingPart/SmallLine.points[1] = pos

func _process(delta: float) -> void:
	if not player_in_proximity:
		return
	$Polygon2D/RotatingPart.look_at(player.global_position)
	$Polygon2D/RotatingPart.rotation_degrees -= 90
#	raycast.cast_to = player.position
#	raycast.enabled = true
#	print(raycast.get_collider())
	if raycast.is_colliding() and not shot:
		shot = true
#		print("collision")
		var line_tween = $LineTween
		line_tween.interpolate_method(self, "set_point", Vector2(0,0), player.position, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
#		line_tween.interpolate_property(line, "points.1",
#		Vector2(0,0), player.position, 0.5,
#		Tween.TRANS_LINEAR, Tween.EASE_OUT)
		line_tween.start()
		print("Started")
	
#	raycast.enabled = false
func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	player_in_proximity = true

func _on_Area2D_body_exited(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	player_in_proximity = false
