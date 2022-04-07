extends KinematicBody2D

export var speed := 250
export var jump_speed := 200
export var gravity := 300 

export var velocity := Vector2.ZERO



var friction := 0.2
var acceleration := 0.2
var deceleration := 0.2

func get_input() -> void:

	var input_dir = 0
	if Input.is_action_pressed("move_right"):
		input_dir += 1
	if Input.is_action_pressed("move_left"):
		input_dir -= 1
	if input_dir != 0:
		# accelerate when there's input
		if velocity.x > speed:
			velocity.x = lerp(velocity.x, input_dir * speed, deceleration)

			# Hard cap speed
			velocity.x = clamp(velocity.x, -speed*2, speed*2)
		else:
			velocity.x = lerp(velocity.x, input_dir * speed, acceleration)
	else:
		# slow down when there's no input
		velocity.x = lerp(velocity.x, 0, deceleration)

func handle_jump() -> void:
#	if is_on_floor() or floor_raycast.is_colliding():
#		buffer_frames_left = 5
#	elif buffer_frames_left > 0:
#		buffer_frames_left -= 1
##
#	if Input.is_action_just_pressed("move_up"):
#		if buffer_frames_left > 0:
#
#			velocity.y = -jump_speed
#			buffer_frames_left = 0
	pass

func _physics_process(delta: float) -> void:
	get_input()
	handle_jump()
	
	if position.y > 1500 or position.y < -400:
		Game.lose()
		
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
