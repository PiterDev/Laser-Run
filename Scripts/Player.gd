# Movement from https://kidscancode.org/godot_recipes/2d/platform_character/
extends KinematicBody2D

export var glitch := 0
export var glitch_limit := 100

export var speed := 250
export var jump_speed := 200
export var gravity := 300 # 300

export var laser_boost_speed := 2/100
export var laser_start_boost_speed := 5/100

export var laser_max_ammo := 20
export var laser_ammo: float = laser_max_ammo setget ammo_changed, get_ammo
export var laser_start_use := 0.5

export var avg_velocity := 100.0


export var velocity := Vector2.ZERO
var last_mouse_pos := Vector2.ZERO
var is_shooting := false
var shoot_stopped := false setget shoot_stop_changed
var reload_started := false


onready var floor_raycast = $Raycasts/JumpCast


signal on_ammo_used(new_ammo)
signal shooting_started
signal shooting_stopped

func _ready() -> void:
	Game.player = self

func shoot_stop_changed(new_value: bool):
	shoot_stopped = new_value
	if shoot_stopped:
		emit_signal("shooting_stopped")
	else:
		emit_signal("shooting_started")

func ammo_changed(new_value) -> void:
	laser_ammo = new_value
	emit_signal("on_ammo_used", new_value)
	
	if new_value < laser_max_ammo and not is_shooting and not reload_started:
		
		$Timers/ReloadTimer.start()
		reload_started = true

func get_ammo() -> float:
	return laser_ammo

func shoot_stop() -> void:
	is_shooting = false
#	emit_signal("shooting_stopped")
	ammo_changed(laser_ammo)
	$Laser.points[1] = Vector2.ZERO
	$Laser.visible = false
	$Particles2D.emitting = false
	$Particles2D.position = Vector2.ZERO
	$Tweens/ShootTween.stop_all()
	

func use_ammo_tween() -> void:
	var shoot_tween = $Tweens/ShootTween
	if shoot_tween.is_active():
		return
	
	var tween_time := (laser_ammo + 1) * 0.2
	shoot_tween.interpolate_property(
		
		self, "laser_ammo", laser_ammo, 0.0, tween_time, 1, Tween.TRANS_LINEAR, Tween.EASE_IN
		
		)
	shoot_tween.start()


func _shoot() -> void:
		if laser_ammo <= 0 and not shoot_stopped:
			$Laser.visible = false
			shoot_stop() 
			self.shoot_stopped = true
			return
		
		$LaserRayCast.cast_to = get_local_mouse_position() * 100
		var laser_collision_point: Vector2 = $LaserRayCast.get_collision_point()
		var laser_local_collision_point = to_local(laser_collision_point)
		if $LaserRayCast.is_colliding():
			
			$Laser.points[1] = laser_local_collision_point + laser_local_collision_point.normalized() * 5 
			# make it a little longer so it clips into ground
			
		else:
			$Laser.points[1] = get_local_mouse_position() * 100
		$Particles2D.position = $Laser.points[1]
		#$Particles2D.rotation = $Laser.get_angle_to($Laser.points[1])
		var dir_to: Vector2 = $Laser.points[0].direction_to($Laser.points[1]) * 100
		$Particles2D.process_material.gravity = Vector3(dir_to[0], dir_to[1], 0)
		$Particles2D.emitting = true
		
		
		
#		$Laser.points[1] = $Preview.points
		$Laser.visible = true
		var direction_to_mouse = global_position.direction_to(get_global_mouse_position()) * -1
		direction_to_mouse.x *= 2 # x movement too slow ):
		velocity += direction_to_mouse * laser_boost_speed


func shoot_process() -> void:
		# Shooting stuff
#	laser_ammo = 1000000000000000
	var started_shooting := Input.is_action_just_pressed("shoot")
	
	
	if started_shooting:
		if laser_ammo >= laser_start_use:
			is_shooting = true
#			emit_signal("shooting_started")
			self.shoot_stopped = false
			$Tweens/ReloadTween.stop_all()
			$Timers/ReloadTimer.stop()
			reload_started = false
			self.laser_ammo -= laser_start_use
			var direction_to_mouse = global_position.direction_to(get_global_mouse_position()) * -1
			velocity += direction_to_mouse * laser_start_boost_speed
			use_ammo_tween()

	if not Input.is_action_pressed("shoot") and not shoot_stopped:
		shoot_stop()
		self.shoot_stopped = true
	
	
	$PreviewRaycast.cast_to = get_local_mouse_position().normalized() * 100
	var preview_collision_point: Vector2 = $PreviewRaycast.get_collision_point()
	var preview_local_collision_point = to_local(preview_collision_point)
	
	var local_mouse_position = get_local_mouse_position()
	
	if $PreviewRaycast.is_colliding():
		$Preview.points[1] = preview_local_collision_point
	else:
		$Preview.points[1] = local_mouse_position.normalized() * 100
	
	if is_shooting:
		_shoot()

var friction = 0.2
var acceleration = 0.2
var deceleration = 0.2
func get_input() -> void:
	# Movement (:
#	velocity.x = 0
#	if Input.is_action_pressed("move_right"):
#		velocity.x += speed
#	if Input.is_action_pressed("move_left"):
#	if Input.is_action_pressed("move_left"):
#		velocity.x -= speed
#	last_mouse_pos = get_global_mouse_position()
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

		
#func handle_bounce() -> void:
#	if get_slide_count() == 0:
#		return
#	velocity += get_slide_collision(0).normal * 10

var buffer_frames_left := 0

func handle_jump() -> void:
	
	if is_on_floor() or floor_raycast.is_colliding():
		buffer_frames_left = 5
	elif buffer_frames_left > 0:
		buffer_frames_left -= 1
	
	if Input.is_action_just_pressed("move_up"):
		if buffer_frames_left > 0:
			
			velocity.y = -jump_speed
			buffer_frames_left = 0

var added_values := 0
func update_avg(new_velocity: float):
	added_values += 1
	
	avg_velocity = avg_velocity + ((new_velocity - avg_velocity) / added_values)

func _on_UpdateAverageTimer_timeout() -> void:
	update_avg(velocity.x)


func _physics_process(delta: float) -> void:
	get_input()
	shoot_process()
	handle_jump()
	if position.y > 1500 or position.y < -400:
		Game.lose()
#	handle_bounce()



#	velocity.y += gravity * delta
	
	velocity.y += gravity * delta
	
	
#	if velocity.x > 0:
#		velocity.x -= 150.0 * delta
#	elif velocity.x < 0:
#		velocity.x += 150.0 * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	

	




func _on_ReloadTimer_timeout() -> void:
	reload_started = false
	var reload_tween = $Tweens/ReloadTween
	if reload_tween.is_active():
		return
	
	var tween_time := (laser_max_ammo - laser_ammo) / 2.0
	reload_tween.interpolate_property(
		
		self, "laser_ammo", laser_ammo, laser_max_ammo, tween_time, 1, Tween.TRANS_LINEAR, Tween.EASE_IN
		
		)
	reload_tween.start()
	print("Reloading...")



