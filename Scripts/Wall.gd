extends KinematicBody2D

var moving := false
signal lose

var default_speed := 150.0
var off_screen_speed := 300.0

var speeding_up := false 
var slowing_down := false

export var speed := 0.0

var offscreen := false
var onscreen := false

func _ready() -> void:
	$MoveTimer.start()
	
func _physics_process(_delta: float) -> void:
	if not moving: return
	if $Speedup.is_on_screen() and not slowing_down and speed == off_screen_speed:
		slowing_down = true
		onscreen = true
		offscreen = false
		slowdown()
	if not $Speedup.is_on_screen() and not speeding_up and speed == default_speed:
		speeding_up = true
		offscreen = true
		onscreen = false
		speedup()
	
	move_and_slide(Vector2.RIGHT * speed)
	
	
	
# warning-ignore:return_value_discarded
	
	

func speedup():
	$Tweens/SlowDownTween.stop_all()
	$SpeedTween.interpolate_property(

	self, "speed", speed, off_screen_speed, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN

	)
	print("yooo")
	speed = off_screen_speed
	$Tweens/SpeedUpTween.start()

func slowdown():
	$Tweens/SpeedUpTween.stop_all()
	$Tweens/SlowDownTween.interpolate_property(

	self, "speed", speed, default_speed, 3.0, Tween.TRANS_CUBIC, Tween.EASE_OUT

	)
	$Tweens/SlowDownTween.start()

func _on_MoveTimer_timeout() -> void:
	$Tweens/StartTween.interpolate_property(

		self, "speed", speed, default_speed, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN

		)
	$Tweens/StartTween.start()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	emit_signal("lose")
# warning-ignore:return_value_discarded
	Game.write_json_file(Game.score_path, Game.scores)
	print("Writing data...")
	get_tree().change_scene("res://Scenes/Lose.tscn")






func _on_StartTween_tween_all_completed() -> void:
	moving = true


func _on_SlowDownTween_tween_all_completed() -> void:
	slowing_down = false


func _on_SpeedUpTween_tween_all_completed() -> void:
	speeding_up = false
