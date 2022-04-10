extends Node2D

export var line_from := Vector2.ZERO
export var line_to := Vector2.ZERO setget line_set

signal disappeared(laser)
signal player_touched

func enable_collisions() -> void:
	print("Enabling")
	$LaserArea/CollisionShape2D.set_deferred("disabled", false)
	$LaserArea.visible = true
	
func disable_collisions() -> void:
	print("Disabling")
	$LaserArea/CollisionShape2D.set_deferred("disabled", true)
	$LaserArea.visible = false
	
func ready() -> void:
	disable_collisions()

func line_set(new_val: Vector2) -> void:

	var glob_line_from := line_from
	var glob_line_to := line_to

	line_from = to_local(line_from)
	line_to = to_local(line_to)
	$Line2D.width = 0
	$Line2D.points[0] = line_from
	$Line2D.points[1] = new_val
	
	var collision_shape = $LaserArea/CollisionShape2D
	
	collision_shape.shape.a = $Line2D.points[0]
	collision_shape.shape.b = $Line2D.points[1]
	show_small_line()

func show_small_line() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 1.0, 0.2)
	$Tween.start()
	$AppearTimer.start()
func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 1.0, 20.0, 0.2)
	$Tween.start()
	$DissapearTimer.start()
#	$LaserArea/CollisionShape2D.set_deferred("disabled", false)
	
func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 20.0, 0, 0.2)
	$Tween.start()
	
func _on_DissapearTimer_timeout() -> void:
	disappear()


func _on_Tween_tween_completed(object: Object, _key: NodePath) -> void:
	if object.width == 0:
		disable_collisions()
		emit_signal("disappeared", self)
	elif object.width == 20.0:
		enable_collisions()
		print("Full size")
		$LaserArea.visible = true
		if len($LaserArea.get_overlapping_bodies()) > 0:
			print("Touched after tween!")
			emit_signal("player_touched")


func _on_AppearTimer_timeout() -> void:
	print("Appearing")
	appear()


func _on_LaserArea_body_entered(body: Node) -> void:
	print("Touched!")
	emit_signal("player_touched")
