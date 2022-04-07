extends KinematicBody2D

export var glitch_points := 0

export var laser_ammo := 0.0 setget set_laser_ammo
export var laser_max_ammo := 50.0

onready var shader_material: ShaderMaterial = $GlitchShader.material
onready var shake_rate = shader_material.get_shader_param("shake_rate")
onready var shake_color_rate = shader_material.get_shader_param("shake_color_rate")

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
	
	if glitch_points >= 10:
		$GlitchShader.visible = true
		
		var shake_value = clamp(glitch_points/100, 0, 1)
		shake_rate = shake_value
		shader_material.set_shader_param("shake_rate", shake_value)
		print(shake_rate)
		var color_rate_value = clamp(glitch_points/1000, 0.01, 0.1)
		shake_color_rate = color_rate_value
		shader_material.set_shader_param("shake_color_rate", color_rate_value)
		
	else:
		$GlitchShader.visible = false
	
	laser_ammo = $Laser.laser_ammo 
