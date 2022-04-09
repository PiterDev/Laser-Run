extends KinematicBody2D

var moving := false
signal wall_touched
signal is_close

var default_speed := 250.0


var off_screen_speed := 500.0

var speeding_up := false 
var slowing_down := false

export var speed := 0.0

var offscreen := false
var onscreen := false

func _ready() -> void:
	$MoveTimer.start()
	
func _physics_process(_delta: float) -> void:
	# var player_average: float = Game.player.avg_speed

	# default_speed = player_average/2
	# if player_average * 2 > off_screen_speed:
	# 	off_screen_speed = player_average*2


	if not moving: return
	if $Speedup.is_on_screen():
		emit_signal("is_close")
	
	if $Speedup.is_on_screen() and not slowing_down and speed == off_screen_speed:
		slowing_down = true
		onscreen = true
		offscreen = false
		slowdown()
		print("Player on screen!")
	if not $Speedup.is_on_screen() and not speeding_up and speed == default_speed:
		speeding_up = true
		offscreen = true
		onscreen = false
		speedup()
		print("Player is off-screen")
		
	move_and_slide(Vector2.RIGHT * speed)
	
	
	
# warning-ignore:return_value_discarded
	
	

func speedup():
	$Tweens/SlowDownTween.stop_all()
	slowing_down = false
	$SpeedTween.interpolate_property(

	self, "speed", speed, off_screen_speed, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN

	)
	print("yooo")
	speed = off_screen_speed
	$Tweens/SpeedUpTween.start()

func slowdown():
	$Tweens/SpeedUpTween.stop_all()
	speeding_up = false
	$Tweens/SlowDownTween.interpolate_property(

	self, "speed", speed, default_speed, 3.0, Tween.TRANS_CUBIC, Tween.EASE_OUT

	)
	$Tweens/SlowDownTween.start()

func _on_MoveTimer_timeout() -> void:
	$Tweens/StartTween.interpolate_property(

		self, "speed", speed, default_speed, 7.0, Tween.TRANS_LINEAR, Tween.EASE_IN

		)
	$Tweens/StartTween.start()


func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return
	emit_signal("wall_touched")






func _on_StartTween_tween_all_completed() -> void:
	print("New wall speed:" + str(speed))
	moving = true


func _on_SlowDownTween_tween_all_completed() -> void:
	print("New wall speed:" + str(speed))
	slowing_down = false


func _on_SpeedUpTween_tween_all_completed() -> void:
	print("New wall speed: " + str(speed))
	speeding_up = false
