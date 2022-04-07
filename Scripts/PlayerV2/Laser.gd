extends Node2D

export var should_shoot := false

export var laser_ammo := 50.0
export var laser_max_ammo := 50.0

export var laser_boost_speed := 20

var is_reloading := false
var reload_timer_started := false

var Movement

var is_shooting := false

onready var laser_sound = owner.get_node("Audio").get_node("LaserSound")

func _ready() -> void:
	Movement = owner.get_node("Scripts").get_node("Movement")
	$Raycasts/LaserRayCast.add_exception(owner)
	$Raycasts/PreviewRaycast.add_exception(owner)
	
func _process(_delta: float) -> void:
	$Raycasts/PreviewRaycast.cast_to = get_local_mouse_position().normalized() * 100
	var preview_collision_point: Vector2 = $Raycasts/PreviewRaycast.get_collision_point()
	var preview_local_collision_point = to_local(preview_collision_point)
	
	var local_mouse_position = get_local_mouse_position()
	
	if $Raycasts/PreviewRaycast.is_colliding():
		$Lines/Preview.points[1] = preview_local_collision_point
	else:
		$Lines/Preview.points[1] = local_mouse_position.normalized() * 100
	

	# Reload logic
	if is_reloading:
		if laser_ammo == laser_max_ammo:
			print("Reloaded")
			is_reloading = false
#		laser_ammo = stepify(lerp(laser_ammo, laser_max_ammo, 0.05), 0.01)
		print("Ammo: " + str(laser_ammo))
	
	# Shooting Logic
	if not should_shoot: 
		$Lines/Laser.points[1] = Vector2(0,0)
		if not is_reloading and not reload_timer_started: 
			reload_timer_started = true
			$ReloadTimer.start()
		laser_sound.stop()
		is_shooting = false
		return
	if laser_ammo <= 0:
		laser_ammo = 0.0
		$Lines/Laser.points[1] = Vector2(0,0)
		if not is_reloading and not reload_timer_started and owner.is_on_floor(): 
			reload_timer_started = true
			$ReloadTimer.start()
			print("Starting reload")
		laser_sound.stop()
		is_shooting = false
		return
	
	if is_reloading:
		is_reloading = false
	if not laser_sound.playing:
		laser_sound.play()
	is_shooting = true
	
	$Raycasts/LaserRayCast.cast_to = get_local_mouse_position() * 100
	var laser_collision_point: Vector2 = $Raycasts/LaserRayCast.get_collision_point()
	var laser_local_collision_point = to_local(laser_collision_point)
	if $Raycasts/LaserRayCast.is_colliding():

		$Lines/Laser.points[1] = laser_local_collision_point + laser_local_collision_point.normalized() * 5 
		# make it a little longer so it clips into ground
			
	else:
		$Lines/Laser.points[1] = get_local_mouse_position() * 100

		
			
		
#	$Laser.points[1] = $Preview.points
	$Lines/Laser.visible = true
	var direction_to_mouse = global_position.direction_to(get_global_mouse_position()) * -1
	direction_to_mouse.x *= 2 # x movement too slow ):
	Movement.velocity += direction_to_mouse * laser_boost_speed
	
#	laser_ammo = stepify(lerp(laser_ammo, 0, 0.01), 0.01)
	print("Ammo: " + str(laser_ammo))
	


func _on_ReloadTimer_timeout() -> void:
	print("Reloading...")
	reload_timer_started = false
	is_reloading = true




func _on_AmmoChangeTimer_timeout() -> void:
	if is_shooting:
		laser_ammo = clamp(laser_ammo - 1, 0, laser_max_ammo)
	elif is_reloading:
		laser_ammo = clamp(laser_ammo + 1, 0, laser_max_ammo)
		
