extends Node2D

var player_in_proximity := false

onready var player = Game.player
onready var raycast = $Polygon2D/RotatingPart/RayCast2D
onready var line = $Polygon2D/RotatingPart/SmallLine

var shot := false

func _ready() -> void:
	print(Vector2(10,10).normalized()*1000)
	line.set_as_toplevel(true)
	line.points[0] = $Polygon2D/RotatingPart.global_position
	line.points[1] = $Polygon2D/RotatingPart.global_position
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
	raycast.force_raycast_update()
	if raycast.is_colliding() and not shot:
		shot = true
#		print("collision")
		var line_tween = $LineTween
		line_tween.interpolate_method(self, "set_point",
		 $Polygon2D/RotatingPart.position,
		 player.position.normalized()*10, 0.1,
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


func _on_LineTween_tween_completed(_object: Object, key: NodePath) -> void:
	print(str($Polygon2D/RotatingPart/SmallLine.points[1]) + " Yo")
