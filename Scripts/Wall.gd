extends KinematicBody2D

var moving := false
signal lose

var default_speed := 90.0
var off_screen_speed := 130.0
var speeding := false


export var speed := 60.0

func _ready() -> void:
	$MoveTimer.start()
	
	
func _physics_process(delta: float) -> void:
	if not moving:
		return
	if $Visibility.is_on_screen():
		if speeding:
			print("Slowing wall down")
			slowdown()
			speeding = false
	else:
		if not speeding:
			print("Speeding wall up")
			speedup()
			speeding = true
	
	
	move_and_slide(Vector2.RIGHT * speed)
	

func speedup():
	$SpeedTween.stop_all()
	$SpeedTween.interpolate_property(

	self, "speed", speed, off_screen_speed, 3.0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN

	)
	$SpeedTween.start()

func slowdown():
	$SpeedTween.stop_all()
	$SpeedTween.interpolate_property(

	self, "speed", speed, default_speed, 1.0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN

	)
	$SpeedTween.start()

func _on_MoveTimer_timeout() -> void:
	moving = true
	$SpeedTween.interpolate_property(

		self, "speed", speed, default_speed, 15.0, 1, Tween.TRANS_LINEAR, Tween.EASE_IN

		)
	$SpeedTween.start()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	emit_signal("lose")
	get_tree().change_scene("res://Scenes/Lose.tscn")


func _on_SpeedTween_tween_completed(object: Object, key: NodePath) -> void:
	print(object)
