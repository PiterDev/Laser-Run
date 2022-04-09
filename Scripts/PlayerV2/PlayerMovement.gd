extends Node

export var speed := 250
export var jump_speed := 180
export var gravity := 300 

export var velocity := Vector2.ZERO



var friction := 0.2
var acceleration := 0.2
var deceleration := 0.2

onready var player = owner
onready var laser = player.get_node("Laser")
onready var jump_sound = player.get_node("Audio").get_node("JumpSound")

var jumps_made := 2
var max_jumps := 3

func _physics_process(delta: float) -> void:
	get_input()
	handle_jump()
	
#	if player.position.y > 1500 or player.position.y < -400:
#		Game.lose()
		
	velocity.y += gravity * delta
	velocity = player.move_and_slide(velocity, Vector2.UP)


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
	if Input.is_action_just_pressed("shoot"):
		laser.should_shoot = true
	if Input.is_action_just_released("shoot"):
		laser.should_shoot = false
		
	if player.is_on_floor():
		jumps_made = 0
	
func handle_jump() -> void:
	var laser = player.get_node("Laser")
#	if not player.is_on_floor(): return 
#	if not player.is_on_floor(): return

	var should_jump: bool = (
		
		Input.is_action_just_pressed("move_up") 
		and laser.laser_ammo >= 15
		
	)
	
	
	if  should_jump:
		laser.laser_ammo -= 15
		jumps_made += 1
		velocity.y = -jump_speed
		jump_sound.play()



