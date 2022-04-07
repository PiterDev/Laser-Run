extends KinematicBody2D

export var glitch_points := 0

export var laser_ammo := 0.0 setget set_laser_ammo
export var laser_max_ammo := 50.0



func _ready() -> void:
	Game.player = self
	laser_max_ammo = $Laser.laser_max_ammo 

func set_laser_ammo(new_value):
	if new_value > laser_max_ammo:
		laser_ammo = laser_ammo
	else:
		laser_ammo = new_value
	
	$Laser.laser_ammo = laser_ammo
	
func _process(_delta: float) -> void:
	if glitch_points >= 100:
		print("Should Lose")
	laser_ammo = $Laser.laser_ammo 
