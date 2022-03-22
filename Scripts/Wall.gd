extends KinematicBody2D

var moving := false
signal lose

export var speed: float = 60.0

func _ready() -> void:
	$MoveTimer.start()
	
	
func _physics_process(delta: float) -> void:
	if not moving:
		return
	move_and_slide(Vector2.RIGHT * speed)
	


func _on_MoveTimer_timeout() -> void:
	moving = true
	$SpeedTween.interpolate_property(
		
		self, "speed", 60.0, 90.0, 15.0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN
		
		)
	$SpeedTween.start()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	emit_signal("lose")
	get_tree().change_scene("res://Scenes/Lose.tscn")
